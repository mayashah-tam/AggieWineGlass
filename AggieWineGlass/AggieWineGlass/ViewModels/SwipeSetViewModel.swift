//
//  SwipeSetViewModel.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/12/25.
//

import Foundation
import Combine

class SwipeSetViewModel: ObservableObject {
    var preferences: UserPreferences
    var wineDataInfo: WineDataInfo
    var redWineSets: Int
    var whiteWineSets: Int
    var sparklingWineSets: Int
    var dessertWineNum: Int
    var roseWineNum: Int
    @Published var swipeSet: [Wine]
    
    init(preferences: UserPreferences, wineDataInfo: WineDataInfo) {
        self.wineDataInfo = wineDataInfo
        self.preferences = preferences
        redWineSets = 0
        whiteWineSets = 0
        sparklingWineSets = 0
        dessertWineNum = 0
        roseWineNum = 0
        swipeSet = []
    }
    
    func setSwipeSets() {
        if (!preferences.highPersonalization) {
            if (preferences.categories.contains("Red wine") && preferences.categories.contains("White wine") && preferences.categories.contains("Sparkling wine")) {
                redWineSets = 1
                whiteWineSets = 1
                sparklingWineSets = 1
            } else if (preferences.categories.contains("Red wine")) {
                redWineSets = 2
            } else if (preferences.categories.contains("White wine")) {
                whiteWineSets = 2
            } else if (preferences.categories.contains("Sparkling wine")) {
                sparklingWineSets = 1
            } else if (preferences.categories.contains("Dessert wine")) {
                dessertWineNum = 1
            } else if (preferences.categories.contains("Rose wine")) {
                roseWineNum = 2
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
            } else if (preferences.categories.contains("Rose wine")) {
                roseWineNum = 3
            } else if (preferences.categories.contains("Dessert wine")) {
                dessertWineNum = 2
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
    
    func findCategoryWineRandom(filterCategories: [String]) -> Wine? {
        let filteredCategoryWines = wineDataInfo.wines.filter { wine in
            let matchCategory = filterCategories.contains(wine.category)
            return matchCategory
            }
        
        return filteredCategoryWines.randomElement()
    }
    
    func createMiniSet(filterCategory: String) -> [Wine] {
        var miniSet: [Wine] = []
        
        let scaleWineRandom = (findScaleWineRandom(filterCategories: [filterCategory], filterRegionClass: preferences.regionClasses) ?? nil)!
        miniSet.append(scaleWineRandom)
        
        let flavorWineRandom = (findFlavorWineRandom(filterCategories: [filterCategory]) ?? nil)!
        miniSet.append(flavorWineRandom)
        
        let categoryWineRandom = (findCategoryWineRandom(filterCategories: [filterCategory]) ?? nil)!
        miniSet.append(categoryWineRandom)
        
        return miniSet
    }
    
    func miniSetUpdate(miniSet: [Wine], direction: [Bool], threeProfileSpecifics: [String]) {
        //TODO
    }
    
    // MOVE THIS LOGIC TO VIEW
    func completeSwipeSet() {
        setSwipeSets()
        while (redWineSets > 0 || whiteWineSets > 0 || sparklingWineSets > 0 || dessertWineNum > 0 || roseWineNum > 0) {
            if (redWineSets > 0) {
                let miniSet: [Wine] = createMiniSet(filterCategory: "Red wine")
                //miniSetUpdate(miniSet: miniSet, direction: [bool], threeProfileSpecifics: [String])
                redWineSets -= 1
            }
            if (whiteWineSets > 0) {
                let miniSet: [Wine] = createMiniSet(filterCategory: "White wine")
                //miniSetUpdate(miniSet: miniSet, direction: [bool], threeProfileSpecifics: [String])
                whiteWineSets -= 1
            }
            if (sparklingWineSets > 0) {
                let miniSet: [Wine] = createMiniSet(filterCategory: "Sparking wine")
                //miniSetUpdate(miniSet: miniSet, direction: [bool], threeProfileSpecifics: [String])
                sparklingWineSets -= 1
            }
            if (dessertWineNum > 0) {
                var miniSet: [Wine] = []
                if let wine = findCategoryWineRandom(filterCategories: ["Dessert wine"]) {
                    miniSet.append(wine)
                }
                //miniSetUpdate(miniSet: miniSet, direction: [bool], threeProfileSpecifics: [String])
                dessertWineNum -= 1
            }
            if (roseWineNum > 0) {
                var miniSet: [Wine] = []
                if let wine = findCategoryWineRandom(filterCategories: ["Rosé wine"]) {
                    miniSet.append(wine)
                }
                //miniSetUpdate(miniSet: miniSet, direction: [bool], threeProfileSpecifics: [String])
                roseWineNum -= 1
            }
        }
    }
}
