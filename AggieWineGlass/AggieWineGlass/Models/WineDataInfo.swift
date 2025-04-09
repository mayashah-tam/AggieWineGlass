//
//  WineDataInfo.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/8/25.
//

import Combine

class WineDataInfo: ObservableObject {
    static let shared = WineDataInfo()

    @Published var uniqueCategories: Set<String> = []
    @Published var uniqueFlavorProfiles: Set<String> = []
    @Published var uniquePairings: Set<String> = []
    @Published var uniqueFlavorSpecifics: Set<String> = []
    @Published var uniqueRegionClasses: Set<String> = []
    @Published var wines: [Wine] = []
    
    private init(uniqueCategories: Set<String> = [],
                 uniqueFlavorProfiles: Set<String> = [],
                 uniqueFlavorSpecifics: Set<String> = [],
                 uniquePairings: Set<String> = [],
                 uniqueRegionClasses: Set<String> = [],
                 wines: [Wine] = []) {
        
        self.uniqueCategories = uniqueCategories
        self.uniqueFlavorProfiles = uniqueFlavorProfiles
        self.uniqueFlavorSpecifics = uniqueFlavorSpecifics
        self.uniquePairings = uniquePairings
        self.uniqueRegionClasses = uniqueRegionClasses
        self.wines = wines
    }
}
