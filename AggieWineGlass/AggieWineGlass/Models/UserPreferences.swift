//
//  UserPreferences.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/8/25.
//

import Foundation

// creates the user preferences model class to keep track of all user information
class UserPreferences: Codable {
    static let shared = UserPreferences()  // singleton instance

    var drySweetScale: Double
    var tanninScale: Double
    var softAcidityScale: Double
    var lightBoldScale: Double
    var fizzinessScale: Double
    var flavorProfiles: [String]
    var flavorSpecifics: [String]
    var isPairing: Bool
    var pairings: [String]
    
    // initialize with default values
    private init(drySweetScale: Double = 3.0,
                 tanninScale: Double = 3.0,
                 softAcidityScale: Double = 3.0,
                 lightBoldScale: Double = 3.0,
                 fizzinessScale: Double = 3.0,
                 flavorProfiles: [String] = [],
                 flavorSpecifics: [String] = [],
                 isPairing: Bool = false,
                 pairings: [String] = []) {
        
        self.drySweetScale = drySweetScale
        self.tanninScale = tanninScale
        self.softAcidityScale = softAcidityScale
        self.lightBoldScale = lightBoldScale
        self.fizzinessScale = fizzinessScale
        self.flavorProfiles = flavorProfiles
        self.flavorSpecifics = flavorSpecifics
        self.isPairing = isPairing
        self.pairings = pairings
    }
    
}
