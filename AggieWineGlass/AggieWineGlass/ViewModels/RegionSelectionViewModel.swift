
//  RegionSelectionViewModel.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/9/25.
//

import Foundation
import Combine

class RegionSelectionViewModel: ObservableObject {
    var preferences: UserPreferences
    var wineDataInfo: WineDataInfo
    
    init(preferences: UserPreferences, wineDataInfo: WineDataInfo) {
        self.wineDataInfo = wineDataInfo
        self.preferences = preferences
    }

    // function to toggle selection of regions
    func toggleRegionSelection(region: String) {
        if preferences.regionClasses.contains(region) {
            preferences.regionClasses.remove(region)
        } else {
            preferences.regionClasses.insert(region)
        }
        print(preferences.regionClasses)
    }

    func selectAllRegions() {
        preferences.regionClasses = Set(wineDataInfo.uniqueRegionClasses)
        print(preferences.regionClasses)
    }
    
    func clearAllRegions() {
        preferences.regionClasses.removeAll()
        print(preferences.regionClasses)
    }
}
