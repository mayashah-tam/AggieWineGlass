//
//  UserPreferences.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/8/25.
//

import Foundation

// creates the user preferences model class to keep track of all users
class UserPreferences: Codable {
    static let shared = UserPreferences()  // singleton instance

    var drySweetScale: Double
    var tanninScale: Double
    var softAcidityScale: Double
    var lightBoldScale: Double
    var fizzinessScale: Double
    var categories: Set<String>
    var flavorProfiles: Set<String>
    var flavorSpecifics: Set<String>
    var isPairing: Bool
    var pairings: Set<String>
    var regions: Set<String>
    var highPersonalization: Bool
    
    // initialize with default values
    private init(drySweetScale: Double = 3.0,
                 tanninScale: Double = 3.0,
                 softAcidityScale: Double = 3.0,
                 lightBoldScale: Double = 3.0,
                 fizzinessScale: Double = 3.0,
                 categories: Set<String> = [],
                 flavorProfiles: Set<String> = [],
                 flavorSpecifics: Set<String> = [],
                 isPairing: Bool = false,
                 pairings: Set<String> = [],
                 regions: Set<String> = [],
                 highPersonalization: Bool = false) {
        
        self.drySweetScale = drySweetScale
        self.tanninScale = tanninScale
        self.softAcidityScale = softAcidityScale
        self.lightBoldScale = lightBoldScale
        self.fizzinessScale = fizzinessScale
        self.categories = categories
        self.flavorProfiles = flavorProfiles
        self.flavorSpecifics = flavorSpecifics
        self.isPairing = isPairing
        self.pairings = pairings
        self.regions = regions
        self.highPersonalization = highPersonalization
    }
    
}
