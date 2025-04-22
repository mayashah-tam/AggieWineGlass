//
//  PairingSelectionModel.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/9/25.
//

import Foundation
import Combine

class PairingSelectionViewModel: ObservableObject {
    @Published var uniqueFilteredPairings: Set<String> = []
    var preferences: UserPreferences
    var wineDataInfo: WineDataInfo
    
    init(preferences: UserPreferences, wineDataInfo: WineDataInfo) {
        self.wineDataInfo = wineDataInfo
        self.preferences = preferences
    }
    
    func turnOnPairingSelection() {
        preferences.isPairing = true
        print(preferences.isPairing)
    }
    
    func findPairingsBasedOnWineCategories() {
        let filteredWines = wineDataInfo.wines.filter { preferences.categories.contains($0.category) }
        let filteredPairings = filteredWines.map { $0.pairings }.flatMap { $0 }
        uniqueFilteredPairings = Set(filteredPairings)
    }

    func togglePairingSelection(pairing: String) {
        if preferences.pairings.contains(pairing) {
            preferences.pairings.remove(pairing)
        } else {
            preferences.pairings.insert(pairing)
        }
        print(preferences.pairings)
    }

    func selectAllPairings() {
        // this would need to be changed to all associated pairings based on selected wine categories
        preferences.pairings = Set(wineDataInfo.uniquePairings)
        preferences.isPairing = true
        print(preferences.pairings)
    }
    
    func clearAllPairings() {
        preferences.pairings.removeAll()
        print(preferences.pairings)
    }
}

