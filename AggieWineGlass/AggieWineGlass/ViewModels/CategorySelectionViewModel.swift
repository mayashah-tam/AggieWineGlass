//
//  SelectAllViewModel.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/8/25.
//

import Foundation
import Combine

class CategorySelectionViewModel: ObservableObject {
    @Published var preferences = UserPreferences.shared

    // function to toggle selection of categories
    func toggleCategorySelection(category: String) {
        if preferences.categories.contains(category) {
            preferences.categories.remove(category)
        } else {
            preferences.categories.insert(category)
        }
        print(preferences.categories)
    }

    func selectAllCategories() {
        preferences.categories = Set(WineDataInfo.shared.uniqueCategories)
        print(preferences.categories)
    }
    
    func clearAllSelections() {
        preferences.categories.removeAll()
        print(preferences.categories)
    }
}

