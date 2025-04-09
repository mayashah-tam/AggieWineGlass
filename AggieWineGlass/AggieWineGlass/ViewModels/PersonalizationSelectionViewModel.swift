//
//  PersonalizationSelectionViewModel.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/9/25.
//

import Foundation
import Combine

class PersonalizationSelectionViewModel: ObservableObject {
    var preferences: UserPreferences
    
    init(preferences: UserPreferences) {
        self.preferences = preferences
    }
    
    func turnOnMorePersonalization() {
        preferences.highPersonalization = true
        print(preferences.highPersonalization)
    }
    
    func turnOffMorePersonalization() {
        preferences.highPersonalization = false
        print(preferences.highPersonalization)
    }

}
