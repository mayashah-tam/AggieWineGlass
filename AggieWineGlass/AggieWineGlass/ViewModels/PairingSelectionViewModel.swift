//
//  PairingSelectionModel.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/9/25.
//

import Foundation
import Combine

class PairingSelectionModel: ObservableObject {
    @Published var preferences = UserPreferences.shared

    // function to toggle selection of pairings
    func togglePairingSelection(pairing: String) {
        if preferences.pairings.contains(pairing) {
            preferences.pairings.remove(pairing)
        } else {
            preferences.pairings.insert(pairing)
        }
        print(preferences.pairings)
    }

    func selectAllCategories() {
        // this would need to be changed to all associated pairings based on selected wine categories
        preferences.pairings = Set(WineDataInfo.shared.uniquePairings)
        print(preferences.categories)
    }
    
    func clearAllSelections() {
        preferences.pairings.removeAll()
        print(preferences.pairings)
    }
}

