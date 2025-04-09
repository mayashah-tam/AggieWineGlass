//
//  RegionSelectionViewModel.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/9/25.
//

import Foundation
import Combine

class RegionSelectionViewModel: ObservableObject {
    @Published var preferences = UserPreferences.shared

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
        preferences.regionClasses = Set(WineDataInfo.shared.uniqueRegionClasses)
        print(preferences.regionClasses)
    }
    
    func clearAllRegions() {
        preferences.regionClasses.removeAll()
        print(preferences.regionClasses)
    }
}
