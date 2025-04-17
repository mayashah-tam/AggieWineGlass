//
//  SwipeViewModel.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/12/25.
//

import Foundation
import Combine

class SwipeViewModel: ObservableObject {
    var preferences: UserPreferences
    var wineDataInfo: WineDataInfo
    @Published var redWineSets: Int
    @Published var whiteWineSets: Int
    @Published var sparklingWineSets: Int
    @Published var dessertWineNum: Int
    @Published var roseWineNum: Int
    @Published var fortifiedWineNum: Int
    
    init(preferences: UserPreferences, wineDataInfo: WineDataInfo) {
        self.wineDataInfo = wineDataInfo
        self.preferences = preferences
        redWineSets = 0
        whiteWineSets = 0
        sparklingWineSets = 0
        dessertWineNum = 0
        roseWineNum = 0
        fortifiedWineNum = 0
    }
    
    func setSwipeSets() {
        if (!preferences.highPersonalization) {
            if (preferences.categories.contains("Red wine") && preferences.categories.contains("White wine") && preferences.categories.contains("Sparkling wine")) {
                redWineSets = 1
                whiteWineSets = 1
                sparklingWineSets = 1
            } else {
                if (preferences.categories.contains("Red wine")) {
                    redWineSets = 2
                }
                if (preferences.categories.contains("White wine")) {
                    whiteWineSets = 2
                }
                if (preferences.categories.contains("Sparkling wine")) {
                    sparklingWineSets = 1
                }
            }
            if (preferences.categories.contains("Dessert wine")) {
                dessertWineNum = 1
            }
            if (preferences.categories.contains("Rosé wine")) {
                roseWineNum = 2
            }
            if (preferences.categories.contains("Fortified Wine")) {
                fortifiedWineNum = 1
            }
        } else if (preferences.highPersonalization) {
            if (preferences.categories.contains("Red wine") && preferences.categories.contains("White wine") && preferences.categories.contains("Sparkling wine")) {
                redWineSets = 2
                whiteWineSets = 2
                sparklingWineSets = 2
            } else if (preferences.categories.contains("Red wine") && preferences.categories.contains("White wine")) {
                redWineSets = 3
                whiteWineSets = 3
            } else if (preferences.categories.contains("Red wine") && preferences.categories.contains("Sparkling wine")) {
                redWineSets = 3
                sparklingWineSets = 2
            } else if (preferences.categories.contains("White wine") && preferences.categories.contains("Sparkling wine")) {
                whiteWineSets = 3
                sparklingWineSets = 2
            } else if (preferences.categories.contains("Red wine")) {
                redWineSets = 5
            } else if (preferences.categories.contains("White wine")) {
                whiteWineSets = 5
            } else if (preferences.categories.contains("Sparkling wine")) {
                sparklingWineSets = 2
            }
            if (preferences.categories.contains("Rosé wine")) {
                roseWineNum = 3
            }
            if (preferences.categories.contains("Dessert wine")) {
                dessertWineNum = 2
            }
            if (preferences.categories.contains("Fortified Wine")) {
                fortifiedWineNum = 2
            }
        }
        print(redWineSets)
        print(whiteWineSets)
        print(sparklingWineSets)
        print(dessertWineNum)
        print(roseWineNum)
    }
    
    private func wineCBF(filterCategories: [String], filterRegionClass: Set<String>) -> [Wine] {
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
    
    private func findScaleWineRandom(filterCategories: [String], filterRegionClass: Set<String>) -> Wine? {
        let scaleWineResults = wineCBF(filterCategories: filterCategories, filterRegionClass: filterRegionClass)
        if (!scaleWineResults.isEmpty) {
            var scaleWineCosineScores: [String: Double] = [:]
            let userScalePreferences = [preferences.drySweetScale, preferences.tanninScale, preferences.softAcidityScale, preferences.lightBoldScale, preferences.fizzinessScale]
            
            for wine in scaleWineResults {
                let wineScaleValues = [wine.drySweet, wine.tannin, wine.softAcidic, wine.lightBold, wine.fizziness]
                
                let similarityScore = weightedCosineSimilarity(wineScaleValues: wineScaleValues, userScalePrefs: userScalePreferences)
                
                scaleWineCosineScores[wine.id] = similarityScore
            }
            
            let sortedScaleWineList = scaleWineCosineScores
                .sorted(by: { $0.value > $1.value })
                .prefix(20)
            
            if let randomEntry = sortedScaleWineList.randomElement(),
               let selectedWine = scaleWineResults.first(where: { $0.id == randomEntry.key }) {
                return selectedWine
            }
        }
        return nil
    }
    
    private func findFlavorWineRandom(filterCategories: [String]) -> Wine? {
        let filteredCategoryWines = wineDataInfo.wines.filter { wine in
            let matchCategory = filterCategories.contains(wine.category)
            return matchCategory
            }
        
        var flavorWineJaccardScores: [String: Double] = [:]
        for wine in filteredCategoryWines {
            let similarityProfileScore = weightedJaccardSimiliarity(wineAttributeList: wine.flavorProfile, userAttributeNums: preferences.flavorProfilesNum, attribute: "Flavor Profile")
            let similaritySpecificsScore = weightedJaccardSimiliarity(wineAttributeList: wine.profileSpecifics, userAttributeNums: preferences.flavorSpecificsNum, attribute: "Profile Specifics")
            
            let totalScore = similarityProfileScore * 0.6 + similaritySpecificsScore * 0.4
            flavorWineJaccardScores[wine.id] = totalScore
        }
        
        let sortedFlavorWineList = flavorWineJaccardScores
            .sorted(by: { $0.value > $1.value })
            .prefix(20)
        print(sortedFlavorWineList)
        
        if let randomEntry = sortedFlavorWineList.randomElement(),
           let selectedWine = filteredCategoryWines.first(where: { $0.id == randomEntry.key }) {
            return selectedWine
        }
        return nil
    }
    
    func findCategoryWineRandom(filterCategories: [String]) -> Wine {
        let filteredCategoryWines = wineDataInfo.wines.filter { wine in
            let matchCategory = filterCategories.contains(wine.category)
            return matchCategory
            }
        
        if let randomCategoryWine = filteredCategoryWines.randomElement() {
            return randomCategoryWine
        }
        return wineDataInfo.wines.randomElement()!
    }
    
    func createMiniSet(filterCategory: String) -> [Wine] {
        var miniSet: [Wine] = []
        
        var inSet = true
        while (inSet) {
            let scaleWineRandom = findScaleWineRandom(filterCategories: [filterCategory], filterRegionClass: preferences.regionClasses)
            let wineIDs = miniSet.map { $0.id }
            if let wine = scaleWineRandom {
                if !wineIDs.contains(wine.id) {
                    miniSet.append(wine)
                    inSet = false
                }
            } else {
                let alternativeWine = findCategoryWineRandom(filterCategories: [filterCategory])
                if !wineIDs.contains(alternativeWine.id) {
                    miniSet.append(alternativeWine)
                    inSet = false
                }
            }
        }
        
        inSet = true
        while (inSet) {
            let flavorWineRandom = findFlavorWineRandom(filterCategories: [filterCategory])
            let wineIDs = miniSet.map { $0.id }
            if let wine = flavorWineRandom {
                if !wineIDs.contains(wine.id) {
                    miniSet.append(wine)
                    inSet = false
                }
            } else {
                let alternativeWine = findCategoryWineRandom(filterCategories: [filterCategory])
                if !wineIDs.contains(alternativeWine.id) {
                    miniSet.append(alternativeWine)
                    inSet = false
                }
            }
        }
        
        inSet = true
        while (inSet) {
            let categoryWineRandom = findCategoryWineRandom(filterCategories: [filterCategory])
            let wineIDs = miniSet.map { $0.id }
            if !wineIDs.contains(categoryWineRandom.id) {
                miniSet.append(categoryWineRandom)
                inSet = false
            }
        }
        
        
        print(miniSet)
        return miniSet
    }
    
    func miniSetUpdate(miniSet: [Wine], direction: [CardView.SwipeDirection], threeProfileSpecifics: [[String]]) {
        
        print("Old Dry/Sweet: ", preferences.drySweetScale)
        print("Old Tannin: ", preferences.tanninScale)
        print("Old Soft/Acidic: ", preferences.softAcidityScale)
        print("Old Light/Bold: ", preferences.lightBoldScale)
        print("Old Fizziness: ", preferences.fizzinessScale)
        print("Old Flavor Profiles: ", preferences.flavorProfilesNum)
        print("Old Profile Specifics: ", preferences.flavorSpecificsNum)
        
        var numWinesLiked = 0

        var drySweetUpdate: Double = 0.0
        var tanninUpdate: Double = 0.0
        var softAcidicUpdate: Double = 0.0
        var lightBoldUpdate: Double = 0.0
        var fizzinessUpdate: Double = 0.0

        for (index, wine) in miniSet.enumerated() {
            let swipe = index < direction.count ? direction[index] : .none

//            print("🍷 Wine: \(wine.nameOnMenu)")
//            print("Dry/Sweet: \(wine.drySweet)")
//            print("Tannin: \(wine.tannin)")
//            print("Soft/Acidic: \(wine.softAcidic)")
//            print("Light/Bold: \(wine.lightBold)")
//            print("Fizziness: \(wine.fizziness)")
//            print("Flavor Profile: \(wine.flavorProfile)")
//            print("Category: \(wine.category)")
//            print("Profile Specifics: \(profiles.joined(separator: ", "))")
//            print("➡️ Swipe: \(swipe)")
//            print("---")

                if swipe == .right {
                    numWinesLiked += 1
                    drySweetUpdate += wine.drySweet
                    tanninUpdate += wine.tannin
                    softAcidicUpdate += wine.softAcidic
                    lightBoldUpdate += wine.lightBold
                    fizzinessUpdate += wine.fizziness
                    for specific in threeProfileSpecifics[index] {
                        if preferences.flavorSpecifics.contains(specific) {
                            if preferences.flavorSpecificsNum[specific] != nil {
                                preferences.flavorSpecificsNum[specific]! += 0.25
                            } else {
                                preferences.flavorSpecificsNum[specific] = 0.25
                            }
                        } else {
                            preferences.flavorSpecifics.insert(specific)
                            if preferences.flavorSpecificsNum[specific] != nil {
                                preferences.flavorSpecificsNum[specific]! += 0.25
                            } else {
                                preferences.flavorSpecificsNum[specific] = 0.25
                            }
                        }
                        for (key, value) in wineDataInfo.flavorMap {
                            if value.contains(specific) {
                                if (preferences.flavorProfiles.contains(key)) {
                                    if preferences.flavorProfilesNum[key] != nil {
                                        preferences.flavorProfilesNum[key]! += 0.50
                                    } else {
                                        preferences.flavorProfilesNum[key] = 0.50
                                    }
                                } else {
                                    preferences.flavorProfiles.insert(key)
                                    if preferences.flavorProfilesNum[key] != nil {
                                        preferences.flavorProfilesNum[key]! += 0.50
                                    } else {
                                        preferences.flavorProfilesNum[key] = 0.50
                                    }
                                }
                            }
                        }
                    }
                }
            
                if swipe == .left {
                    for specific in threeProfileSpecifics[index] {
                        if preferences.flavorSpecifics.contains(specific) {
                            if var value = preferences.flavorSpecificsNum[specific] {
                                    value -= 0.25
                                    if value <= 0 {
                                        preferences.flavorSpecificsNum.removeValue(forKey: specific)
                                        preferences.flavorSpecifics.remove(specific)
                                    } else {
                                        preferences.flavorSpecificsNum[specific] = value
                                    }
                            }
                        }
                        for (key, value) in wineDataInfo.flavorMap {
                            if value.contains(specific) {
                                if (preferences.flavorProfiles.contains(key)) {
                                    if var value = preferences.flavorSpecificsNum[key] {
                                            value -= 0.50
                                            if value <= 0 {
                                                preferences.flavorSpecificsNum.removeValue(forKey: key)
                                                preferences.flavorSpecifics.remove(key)
                                            } else {
                                                preferences.flavorSpecificsNum[key] = value
                                            }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            if numWinesLiked > 0 {
                drySweetUpdate /= Double(numWinesLiked)
                tanninUpdate /= Double(numWinesLiked)
                softAcidicUpdate /= Double(numWinesLiked)
                lightBoldUpdate /= Double(numWinesLiked)
                fizzinessUpdate /= Double(numWinesLiked)

                preferences.drySweetScale = (0.7 * preferences.drySweetScale) + (0.3 * drySweetUpdate)
                preferences.tanninScale = (0.7 * preferences.tanninScale) + (0.3 * tanninUpdate)
                preferences.softAcidityScale = (0.7 * preferences.softAcidityScale) + (0.3 * softAcidicUpdate)
                preferences.lightBoldScale = (0.7 * preferences.lightBoldScale) + (0.3 * lightBoldUpdate)
                preferences.fizzinessScale = (0.7 * preferences.fizzinessScale) + (0.3 * fizzinessUpdate)
            }
        
        print("New Dry/Sweet: ", preferences.drySweetScale)
        print("New Tannin: ", preferences.tanninScale)
        print("New Soft/Acidic: ", preferences.softAcidityScale)
        print("New Light/Bold: ", preferences.lightBoldScale)
        print("New Fizziness: ", preferences.fizzinessScale)
        print("New Flavor Profiles: ", preferences.flavorProfilesNum)
        print("New Profile Specifics: ", preferences.flavorSpecificsNum)

    }

}
