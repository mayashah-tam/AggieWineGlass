//
//  FlavorProfileSelectionModel.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/9/25.
//

import Foundation
import Combine

class FlavorProfileSelectionViewModel: ObservableObject {
    var preferences: UserPreferences
    var wineDataInfo: WineDataInfo
    
    init(preferences: UserPreferences, wineDataInfo: WineDataInfo) {
        self.wineDataInfo = wineDataInfo
        self.preferences = preferences
    }

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
        preferences.flavorProfiles = Set(wineDataInfo.uniqueFlavorProfiles)
        print(preferences.flavorProfiles)
    }
    
    func clearAllFlavorProfiles() {
        preferences.flavorProfiles.removeAll()
        print(preferences.flavorProfiles)
    }
    
    func setProfileSpecifics() {
        for profile in preferences.flavorProfiles {
            for profileSpecific in wineDataInfo.flavorMap[profile] ?? [] {
                if !preferences.flavorSpecifics.contains(profileSpecific) {
                    preferences.flavorSpecifics.insert(profileSpecific)
                }
            }
        }
        print(preferences.flavorSpecifics)
    }
}


