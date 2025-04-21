//
//  RecommendationViewModel.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/12/25.
//

import Foundation
import Combine

class RecommendationViewModel: ObservableObject {
    var preferences: UserPreferences
    var wineDataInfo: WineDataInfo
    
    init(preferences: UserPreferences, wineDataInfo: WineDataInfo) {
        self.wineDataInfo = wineDataInfo
        self.preferences = preferences
    }
    
    private func wineCBF(filterCategories: Set<String>, filterRegionClass: Set<String>) -> [Wine] {
        let filteredCBFWines = wineDataInfo.wines.filter { wine in

            let matchCategory = filterCategories.contains(wine.category)
            let matchRegionClass = filterRegionClass.contains(wine.regionClass)
            
            let matchDrySweet = wine.drySweet >= preferences.drySweetScale - 1.5 && wine.drySweet <= preferences.drySweetScale + 1.5
            
            let matchTannin = wine.tannin >= preferences.tanninScale - 3.0 && wine.tannin <= preferences.tanninScale + 3.0
            
            let matchSoftAcidic = wine.softAcidic >= preferences.softAcidityScale - 3.0 && wine.softAcidic <= preferences.softAcidityScale + 3.0
            
            let matchLightBold = wine.lightBold >= preferences.lightBoldScale - 2.0 && wine.lightBold <= preferences.lightBoldScale + 2.0

            return matchCategory &&
                    matchRegionClass &&
                    matchDrySweet &&
                    matchTannin &&
                    matchSoftAcidic &&
                    matchLightBold
            }
        return filteredCBFWines
    }
    
    private func wineCBFNoRegion(filterCategories: Set<String>) -> [Wine] {
        let filteredCBFWines = wineDataInfo.wines.filter { wine in

            let matchCategory = filterCategories.contains(wine.category)
            
            let matchDrySweet = wine.drySweet >= preferences.drySweetScale - 1.5 && wine.drySweet <= preferences.drySweetScale + 1.5
            
            let matchTannin = wine.tannin >= preferences.tanninScale - 3.0 && wine.tannin <= preferences.tanninScale + 3.0
            
            let matchSoftAcidic = wine.softAcidic >= preferences.softAcidityScale - 3.0 && wine.softAcidic <= preferences.softAcidityScale + 3.0
            
            let matchLightBold = wine.lightBold >= preferences.lightBoldScale - 2.0 && wine.lightBold <= preferences.lightBoldScale + 2.0

            return matchCategory &&
                    matchDrySweet &&
                    matchTannin &&
                    matchSoftAcidic &&
                    matchLightBold
            }
        return filteredCBFWines
    }
    
    private func weightedCosineSimilarity(wineScaleValues: [Double], userScalePrefs: [Double]) -> Double {
        let weights: [Double] = [0.20, 0.20, 0.30, 0.20, 0.10]

        let weightedWine = zip(weights, wineScaleValues).map(*)
        let weightedUser = zip(weights, userScalePrefs).map(*)

        let dotProduct = zip(weightedWine, weightedUser).map(*).reduce(0, +)

        let magnitudeWine = sqrt(weightedWine.map { $0 * $0 }.reduce(0, +))
        let magnitudeUser = sqrt(weightedUser.map { $0 * $0 }.reduce(0, +))

        let denominator = magnitudeWine * magnitudeUser
        return denominator != 0 ? dotProduct / denominator : 0.0
    }

    private func weightedJaccardSimiliarity(wineAttributeList: [String], userAttributeNums: [String: Double], attribute: String) -> Double {
        
        let vector = userAttributeNums.values
        let magnitude = sqrt(vector.map { $0 * $0 }.reduce(0, +))
        guard magnitude != 0 else { return 0.0 }
        let weightsMap = userAttributeNums.mapValues { $0 / magnitude }
        
        var selectedWeights: [Double] = []
        for attribute in wineAttributeList {
            selectedWeights.append(weightsMap[attribute] ?? 0.0)
        }
        
        // build the user attribute binary vector
        var userAttributeListBinary: [Double] = []
        for attribute in wineAttributeList {
            if userAttributeNums.keys.contains(attribute) {
                userAttributeListBinary.append(1.0)
            } else {
                userAttributeListBinary.append(1.0)
            }
        }
        
        // build the wine category preference binary vector
        let wineAttributeListBinary: [Double] = Array(repeating: 1.0, count: wineAttributeList.count)
        
        // compute weighted intersection and union
        let zippedPairs = zip(userAttributeListBinary, wineAttributeListBinary)
        let weightedValues: [Double] = zippedPairs.enumerated().map { (index, pair) in
            let userBit = pair.0
            let wineBit = pair.1
            if (Int(userBit) & Int(wineBit)) == 1 {
                return selectedWeights[index]
            } else {
                return 0.0
            }
        }
        let intersection = weightedValues.reduce(0, +)
        
        let zippedPairsUnion = zip(userAttributeListBinary, wineAttributeListBinary)
        let weightedUnionValues: [Double] = zippedPairsUnion.enumerated().map { (index, pair) in
            let userBit = pair.0
            let wineBit = Int(pair.1)
            if (Int(userBit) | wineBit) == 1 {
                return selectedWeights[index]
            } else {
                return 0.0
            }
        }
        let union = weightedUnionValues.reduce(0, +)
        
        if union != 0 {
            return intersection / union
        } else {
            return 0.0
        }
    }
    
    func cbfWineResults(version: Bool, category: String) -> [Wine] {
        if (version) {
            return wineCBF(filterCategories: Set([category]), filterRegionClass: preferences.regionClasses)
        } else {
            return wineCBFNoRegion(filterCategories: Set([category]))
        }
    }
    
    func recommendationRanking(category: String, version: Bool) -> [(key: String, value: Double)] {
        let cbfWineResults = cbfWineResults(version: version, category: category)
        
        var scaleWineCosineScores: [String: Double] = [:]
        let userScalePreferences = [preferences.drySweetScale, preferences.tanninScale, preferences.softAcidityScale, preferences.lightBoldScale, preferences.fizzinessScale]
        for wine in cbfWineResults {
            let wineScaleValues = [wine.drySweet, wine.tannin, wine.softAcidic, wine.lightBold, wine.fizziness]
            
            let similarityScore = weightedCosineSimilarity(wineScaleValues: wineScaleValues, userScalePrefs: userScalePreferences)
            
            scaleWineCosineScores[wine.id] = similarityScore
        }
        
        var flavorProfileWineJaccardScores: [String: Double] = [:]
        for wine in cbfWineResults {
            let similarityScore = weightedJaccardSimiliarity(wineAttributeList: wine.flavorProfile, userAttributeNums: preferences.flavorProfilesNum, attribute: "Flavor Profile")
            flavorProfileWineJaccardScores[wine.id] = similarityScore
        }
        
        var profileSpecificsWineJaccardScores: [String: Double] = [:]
        for wine in cbfWineResults {
            let similarityScore = weightedJaccardSimiliarity(wineAttributeList: wine.profileSpecifics, userAttributeNums: preferences.flavorSpecificsNum, attribute: "Profile Specifics")
            profileSpecificsWineJaccardScores[wine.id] = similarityScore
        }
        
        var pairingsWineJaccardScores: [String: Double] = [:]
        for wine in cbfWineResults {
            let pairingsNums = Dictionary(uniqueKeysWithValues: preferences.pairings.map { ($0, 1.0) })
            let similarityScore = weightedJaccardSimiliarity(wineAttributeList: wine.pairings, userAttributeNums: pairingsNums, attribute: "Pairings")
            pairingsWineJaccardScores[wine.id] = similarityScore
        }
        
        var totalWineScores: [String: Double] = [:]
        for wine in cbfWineResults {
            var totalScore = 0.0
            if (preferences.isPairing) {
                let cosine = (scaleWineCosineScores[wine.id] ?? 0.0) * 0.20
                let flavorProfile = (flavorProfileWineJaccardScores[wine.id] ?? 0.0) * 0.20
                let profileSpecifics = (profileSpecificsWineJaccardScores[wine.id] ?? 0.0) * 0.20
                let pairings = (pairingsWineJaccardScores[wine.id] ?? 0.0) * 0.20
                let rating = wine.rating/5.0 * 0.20
                
                totalScore = cosine + flavorProfile + profileSpecifics + pairings + rating
            } else {
                let cosine = (scaleWineCosineScores[wine.id] ?? 0.0) * 0.25
                let flavorProfile = (flavorProfileWineJaccardScores[wine.id] ?? 0.0) * 0.25
                let profileSpecifics = (profileSpecificsWineJaccardScores[wine.id] ?? 0.0) * 0.25
                let rating = wine.rating/5.0 * 0.25
                
                totalScore = cosine + flavorProfile + profileSpecifics + rating
            }
            
            totalWineScores[wine.id] = totalScore
        }
        
        let sortedWineList = totalWineScores.sorted { $0.value > $1.value }
        return sortedWineList
    }
    
    func finalRecommendations() -> [Wine] {
        var topRecs: [Wine] = []

        for category in preferences.categories {
            var sortedWineScores = recommendationRanking(category: category, version: true)
            guard !sortedWineScores.isEmpty else {
                continue
            }

            var topCategoryRecs = sortedWineScores.filter { $0.value >= 0.90 }

            if !topCategoryRecs.isEmpty {
                let topCount = Int(ceil(Double(sortedWineScores.count) * 0.1))
                topCategoryRecs = Array(sortedWineScores.prefix(topCount))
            } else {
                topCategoryRecs = sortedWineScores
            }

            if category == "Red wine" || category == "White wine" {
                guard let key1 = topCategoryRecs.randomElement()?.key,
                      let wine1 = wineDataInfo.wines.first(where: { $0.id == key1 }) else {
                    continue
                }

                topRecs.append(wine1)

                var wine2: Wine?
                var attempts = 0
                while wine2 == nil && attempts < 10 {
                    if let newKey = topCategoryRecs.randomElement()?.key,
                       newKey != key1,
                       let newWine = wineDataInfo.wines.first(where: { $0.id == newKey }) {
                        wine2 = newWine
                    }
                    attempts += 1
                }

                if let wine2 = wine2 {
                    topRecs.append(wine2)
                }
            } else {
                if let key = topCategoryRecs.randomElement()?.key,
                   let wine = wineDataInfo.wines.first(where: { $0.id == key }) {
                    topRecs.append(wine)
                }
            }
        }
        print("\n✅ Final Top Recs:")
        for rec in topRecs {
            print("- \(rec.nameOnMenu) (\(rec.category))")
        }
        return topRecs
    }

    func topRecsRestaurants() {
        let topRecs = finalRecommendations()
        var restaurantMapping: [String: [String: Double]] = [:]

        for wine in topRecs {
            let matchingWines = wineDataInfo.wines.filter { $0.id == wine.id }
            for match in matchingWines {
                restaurantMapping[wine.id, default: [:]][match.restaurant] = match.glassPrice
            }
        }
    }
    
    func adventureRecs() -> [Wine] {
        var adventureRecs: [Wine] = []

        for category in preferences.categories {

            var sortedWineScores = recommendationRanking(category: category, version: true)
            if sortedWineScores.isEmpty {
                sortedWineScores = recommendationRanking(category: category, version: false)
            }

            var adventureCategoryRecs = sortedWineScores.filter { $0.value >= 0.7 && $0.value <= 0.9 }

            if adventureCategoryRecs.isEmpty {
                let count = sortedWineScores.count
                let startIndex = Int(ceil(Double(count) * 0.1))
                let endIndex = min(Int(ceil(Double(count) * 0.2)), count)

                if count >= 2, startIndex < endIndex {
                    adventureCategoryRecs = Array(sortedWineScores[startIndex..<endIndex])
                } else {
                    adventureCategoryRecs = sortedWineScores
                }
            }

            if category == "Red wine" || category == "White wine" {
                guard let key1 = adventureCategoryRecs.randomElement()?.key,
                      let wine1 = wineDataInfo.wines.first(where: { $0.id == key1 }) else {
                    continue
                }

                adventureRecs.append(wine1)

                var wine2: Wine?
                var attempts = 0
                while wine2 == nil && attempts < 10 {
                    if let newKey = adventureCategoryRecs.randomElement()?.key,
                       newKey != key1,
                       let newWine = wineDataInfo.wines.first(where: { $0.id == newKey }) {
                        wine2 = newWine
                    }
                    attempts += 1
                }

                if let wine2 = wine2 {
                    adventureRecs.append(wine2)
                } else {
                }

            } else {
                if let key = adventureCategoryRecs.randomElement()?.key,
                   let wine = wineDataInfo.wines.first(where: { $0.id == key }) {
                    adventureRecs.append(wine)
                } else {
                }
            }
        }

        print("\n✅ Final Adventure Recs:")
        for rec in adventureRecs {
            print("- \(rec.nameOnMenu) (\(rec.category))")
        }
        return adventureRecs
    }

    func adventureRecsRestaurants() {
        let adventureRecs = adventureRecs()
        var restaurantMapping: [String: [String: Double]] = [:]

        for wine in adventureRecs {
            let matchingWines = wineDataInfo.wines.filter { $0.id == wine.id }
            for match in matchingWines {
                restaurantMapping[wine.id, default: [:]][match.restaurant] = match.glassPrice
            }
        }
        print("adventure recs resturaunt mapping")
        print(restaurantMapping)
    }
}
