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
        if preferences.regions.contains(region) {
            preferences.regions.remove(region)
        } else {
            preferences.regions.insert(region)
        }
        print(preferences.regions)
    }

    func selectAllRegions() {
        preferences.regions = Set(WineDataInfo.shared.uniqueRegions)
        print(preferences.regions)
    }
    
    func clearAllRegions() {
        preferences.regions.removeAll()
        print(preferences.regions)
    }
}
