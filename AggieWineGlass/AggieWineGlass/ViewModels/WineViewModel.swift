//
//  WineViewModel.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/6/25.
//

import Foundation

class WineViewModel {
    var wines: [Wine] = []
    
    var uniqueCategories: Set<String> = []
    var uniqueFlavorProfiles: Set<String> = []
    var uniqueFlavorSpecifics: Set<String> = []
    var uniquePairings: Set<String> = []
    
    // function to load the wine data from the CSV file
    func loadWineData(filepath: String) {
        if let data = readCSV(filepath: filepath) {
            wines = data.map { row in
                Wine(
                    vivinoLink: row["Vivino Link"] as! String,
                    nameOnMenu: row["Name (on menu)"] as! String,
                    restaurants: row["Restaurant"] as! String,
                    glassPrice: row["Glass Price"] as! Double,
                    bottlePrice: row["Bottle Price"] as! Double,
                    winery: row["Winery"] as! String,
                    year: row["Year"] as! String,
                    wineStyle: row["Wine Style"] as! String,
                    region: row["Region"] as! String,
                    grapeVarieties: row["Grape Varieties"] as! String,
                    abv: row["ABV"] as! Double,
                    drySweet: row["Dry/Sweet"] as! Double,
                    tannin: row["Tannin"] as! Double,
                    softAcidic: row["Soft/Acidic"] as! Double,
                    flavorProfile: convertToList(row["Flavor Profile"] as? String) ,
                    pairings: convertToList(row["Pairings"] as? String) ,
                    rating: row["Rating"] as! Double,
                    category: row["Category"] as! String,
                    lightBold: row["Light/Bold"] as! Double,
                    profileSpecifics: convertToList(row["Profile Specfics"] as? String) ,
                    fizziness: row["Fizziness"] as! Double,
                    country: row["Country"] as! String
                )
            }
            processUniqueValues()
        }
    }
    
    private func readCSV(filepath: String) -> [[String: Any]]? {
        let headerTypes: [String: Any.Type] = [
            "Vivino Link": String.self,
            "Name (on menu)": String.self,
            "Restaurant": String.self,
            "Glass Price": Double.self,
            "Bottle Price": Double.self,
            "Winery": String.self,
            "Year": String.self,
            "Wine Style": String.self,
            "Region": String.self,
            "Grape Varieties": String.self,
            "ABV": Double.self,
            "Dry/Sweet": Double.self,
            "Tannin": Double.self,
            "Soft/Acidic": Double.self,
            "Flavor Profile": [String].self,
            "Pairings": [String].self,
            "Rating": Double.self,
            "Category": String.self,
            "Light/Bold": Double.self,
            "Profile Specfics": [String].self,
            "Fizziness": Double.self,
            "Country": String.self
        ]
        
        do {
            let data = try String(contentsOfFile: filepath, encoding: .utf8)
            let lines = data.components(separatedBy: "\n")
            
            var result = [[String: Any]]()
            let headers = lines[0].components(separatedBy: ",")
            
            func convert(value: String, header: String) -> Any {
                guard let type = headerTypes[header] else {
                    return value
                }
                
                if type == Double.self, let doubleValue = Double(value) {
                    return doubleValue
                } else if type == String.self {
                    return value
                } else if type == [String].self {
                    return value.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
                } else {
                    return value
                }
            }
            
            for line in lines.dropFirst() {
                let values = line.components(separatedBy: ",")
                if values.count == headers.count {
                    var dict = [String: Any]()
                    for (index, header) in headers.enumerated() {
                        let value = values[index]
                        dict[header] = convert(value: value, header: header)
                    }
                    result.append(dict)
                }
            }
            return result
        } catch {
            print("Error reading file: \(error)")
            return nil
        }
    }
    
    private func convertToList(_ value: String?) -> [String] {
        guard let value = value, !value.isEmpty else {
            return []
        }
        
        return value.trimmingCharacters(in: .whitespacesAndNewlines)
                    .trimmingCharacters(in: CharacterSet(charactersIn: "'"))
                    .components(separatedBy: ",")
    }
    
    private func processUniqueValues() {
        let flavorProfiles = wines.map { $0.flavorProfile }.flatMap { $0 }
        let pairings = wines.map { $0.pairings }.flatMap { $0 }
        let profileSpecifics = wines.map { $0.profileSpecifics }.flatMap { $0 }
                
        uniqueCategories = Set(wines.map { $0.category })
        uniqueFlavorProfiles = Set(flavorProfiles)
        uniquePairings = Set(pairings)
        uniqueFlavorSpecifics = Set(profileSpecifics)
    }
}
