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
    
    // this sets the baseline value for the profile and the specifics
    func setProfileSpecifics() {
        for profile in preferences.flavorProfiles {
            // shouldn't be any duplicates, but just a check for it in case
            if (!preferences.flavorProfilesNum.keys.contains(profile)) {
                preferences.flavorProfilesNum[profile] = 3.0
            }
            for profileSpecific in wineDataInfo.flavorMap[profile] ?? [] {
                // shouldn't be any duplicates, but just a check in case
                if (!preferences.flavorSpecifics.contains(profileSpecific)) {
                    preferences.flavorSpecifics.insert(profileSpecific)
                }
                // shouldn't be any overlap in the mapping, but just a check in case
                if (!preferences.flavorSpecificsNum.keys.contains(profileSpecific)) {
                    preferences.flavorSpecificsNum[profileSpecific] = 1.0
                } else {
                    preferences.flavorSpecificsNum[profileSpecific]! += 1.0
                }
            }
        }
        print(preferences.flavorProfilesNum)
        print(preferences.flavorSpecificsNum)
    }
    
}


