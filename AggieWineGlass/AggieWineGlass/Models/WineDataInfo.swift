//
//  WineDataInfo.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/8/25.
//

class WineDataInfo: Codable {
    static let shared = WineDataInfo() // singleton instance
    
    var uniqueCategories: Set<String>
    var uniqueFlavorProfiles: Set<String>
    var uniqueFlavorSpecifics: Set<String>
    var uniquePairings: Set<String>
    
    private init(uniqueCategories: Set<String> = [],
                 uniqueFlavorProfiles: Set<String> = [],
                 uniqueFlavorSpecifics: Set<String> = [],
                 uniquePairings: Set<String> = []) {
        
        self.uniqueCategories = uniqueCategories
        self.uniqueFlavorProfiles = uniqueFlavorProfiles
        self.uniqueFlavorSpecifics = uniqueFlavorSpecifics
        self.uniquePairings = uniquePairings
    }
}
