//
//  SelectAllViewModel.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/8/25.
//

import Foundation
import Combine

class CategorySelectionViewModel: ObservableObject {
    var preferences: UserPreferences
    var wineDataInfo: WineDataInfo
    
    init(preferences: UserPreferences, wineDataInfo: WineDataInfo) {
        self.wineDataInfo = wineDataInfo
        self.preferences = preferences
    }

    func toggleCategorySelection(category: String) {
        if preferences.categories.contains(category) {
            preferences.categories.remove(category)
        } else {
            preferences.categories.insert(category)
        }
        print(preferences.categories)
    }

    func selectAllCategories() {
        preferences.categories = Set(wineDataInfo.uniqueCategories)
        print(preferences.categories)
    }
    
    func clearAllSelections() {
        preferences.categories.removeAll()
        print(preferences.categories)
    }
}
