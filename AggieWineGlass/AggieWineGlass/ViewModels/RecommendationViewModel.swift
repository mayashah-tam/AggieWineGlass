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
    
    func wineCBF(filterCategories: Set<String>, filterRegionClass: Set<String>) -> [Wine] {
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
    
    func weightedCosineSimilarity(wineScaleValues: [Double], userScalePrefs: [Double]) -> Double {
        let weights: [Double] = [0.20, 0.20, 0.30, 0.20, 0.10]

        let weightedWine = zip(weights, wineScaleValues).map(*)
        let weightedUser = zip(weights, userScalePrefs).map(*)

        let dotProduct = zip(weightedWine, weightedUser).map(*).reduce(0, +)

        let magnitudeWine = sqrt(weightedWine.map { $0 * $0 }.reduce(0, +))
        let magnitudeUser = sqrt(weightedUser.map { $0 * $0 }.reduce(0, +))

        let denominator = magnitudeWine * magnitudeUser
        return denominator != 0 ? dotProduct / denominator : 0.0
    }

    func weightedJaccardSimiliarity(wineAttributeList: [String], userAttributeNums: [String: Double], attribute: String) -> Double {
        
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
    
    func recommendationRanking() {
        let cbfWineResults = wineCBF(filterCategories: preferences.categories, filterRegionClass: preferences.regionClasses)
        
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
        // print(sortedWineList)
    }
}
