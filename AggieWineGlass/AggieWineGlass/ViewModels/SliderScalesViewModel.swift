//
//  SliderScalesViewModel.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/8/25.
//

import Foundation
import Combine

class SliderScalesViewModel: ObservableObject {
    @Published var preferences = UserPreferences.shared  // access singleton instance -- this will be a shared user preferneces instance between all classes
        
    func updateDrySweetScale() {
        UserDefaults.standard.set(preferences.drySweetScale, forKey: "UpdateDrySweetScale")
        print("Updated Dry/Sweet Scale: \(preferences.drySweetScale)")
    }
    
    func updateTanninScale() {
        UserDefaults.standard.set(preferences.tanninScale, forKey: "UpdateTanninScale")
        print("Updated Tannin Scale: \(preferences.tanninScale)")
    }
    
    func updateSoftAcidityScale() {
        UserDefaults.standard.set(preferences.softAcidityScale, forKey: "UpdateSoftAcitidyScale")
        print("Updated Soft/Acidity Scale: \(preferences.softAcidityScale)")
    }
    
    func updateLightBoldScale() {
        UserDefaults.standard.set(preferences.lightBoldScale, forKey: "UpdateLightBoldScale")
        print("Updated Light/Bold Scale: \(preferences.lightBoldScale)")
    }
    
    func updateFizzinessScale() {
        UserDefaults.standard.set(preferences.fizzinessScale, forKey: "UpdateFizzinessScale")
        print("Update Fizziness Scale: \(preferences.fizzinessScale)")
    }
    
}
