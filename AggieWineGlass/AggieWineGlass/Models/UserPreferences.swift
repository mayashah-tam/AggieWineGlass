//
//  UserPreferences.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/8/25.
//

import Foundation
import Combine

class UserPreferences: ObservableObject {
    @Published var drySweetScale: Double
    @Published var tanninScale: Double
    @Published var softAcidityScale: Double
    @Published var lightBoldScale: Double
    @Published var fizzinessScale: Double
    @Published var categories: Set<String>
    @Published var flavorProfiles: Set<String>
    @Published var flavorSpecifics: Set<String>
    @Published var flavorProfilesNum: [String: Double]
    @Published var flavorSpecificsNum: [String: Double]
    @Published var isPairing: Bool
    @Published var pairings: Set<String>
    @Published var regionClasses: Set<String>
    @Published var highPersonalization: Bool

    init(drySweetScale: Double = 3.0,
         tanninScale: Double = 3.0,
         softAcidityScale: Double = 3.0,
         lightBoldScale: Double = 3.0,
         fizzinessScale: Double = 0.0,
         categories: Set<String> = [],
         flavorProfiles: Set<String> = [],
         flavorSpecifics: Set<String> = [],
         flavorProfilesNum: [String: Double] = [:],
         flavorSpecificsNum: [String: Double] = [:],
         isPairing: Bool = false,
         pairings: Set<String> = [],
         regionClasses: Set<String> = [],
         highPersonalization: Bool = false) {
        
        self.drySweetScale = drySweetScale
        self.tanninScale = tanninScale
        self.softAcidityScale = softAcidityScale
        self.lightBoldScale = lightBoldScale
        self.fizzinessScale = fizzinessScale
        self.categories = categories
        self.flavorProfiles = flavorProfiles
        self.flavorSpecifics = flavorSpecifics
        self.flavorProfilesNum = flavorProfilesNum
        self.flavorSpecificsNum = flavorSpecificsNum
        self.isPairing = isPairing
        self.pairings = pairings
        self.regionClasses = regionClasses
        self.highPersonalization = highPersonalization
    }
}

