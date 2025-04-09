//
//  FlavorProfileSelectionModel.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/9/25.
//

import Foundation
import Combine

class FlavorProfileSelectionModel: ObservableObject {
    @Published var preferences = UserPreferences.shared

    // function to toggle selection of flavor profiles
    func toggleFlavorProfileSelection(flavorProfile: String) {
        if preferences.flavorProfiles.contains(flavorProfile) {
            preferences.flavorProfiles.remove(flavorProfile)
        } else {
            preferences.flavorProfiles.insert(flavorProfile)
        }
        print(preferences.flavorProfiles)
    }

    func selectAllFlavorProfiles() {
        preferences.flavorProfiles = Set(WineDataInfo.shared.uniqueFlavorProfiles)
        print(preferences.flavorProfiles)
    }
    
    func clearAllFlavorProfiles() {
        preferences.flavorProfiles.removeAll()
        print(preferences.flavorProfiles)
    }
}


