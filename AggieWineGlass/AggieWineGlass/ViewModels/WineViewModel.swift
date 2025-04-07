//
//  WineViewModel.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/6/25.
//

import Foundation

class WineViewModel: ObservableObject {
    @Published var wines: [Wine] = []
    
    var uniqueCategories: Set<String> = []
    var uniqueFlavorProfiles: Set<String> = []
    var uniqueFlavorSpecifics: Set<String> = []
    var uniquePairings: Set<String> = []
    
    // reads in the raw data from the csv file
    // generates lists of unique categories, flavor profiles, flavor specifics, unique pairings
    func loadWineData(filepath: String) {
        readCSV(filepath: filepath)
        processUniqueValues()
    }
    
    func readCSV(filepath: String) {
        do {
            let data = try String(contentsOfFile: filepath, encoding: .utf8)
            let lines = data.components(separatedBy: "\n")
            
            // gets the column headers and cleans up unnecessary characters
            let headers = lines[0].components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: .controlCharacters) }
            
            var tempWines: [Wine] = []
            
            // reads in each wine row
            // converts it to a wine object
            // adds it to a temp list of all wines
            for line in lines.dropFirst() {
                let values = parseCSVLine(line)
                
                if values.count == headers.count {
                    var dict = [String: Any]()
                    for (index, header) in headers.enumerated() {
                        let value = values[index]
                        dict[header] = value
                    }
                    
                    if let wine = createWine(from: dict) {
                        tempWines.append(wine)
                    } else {
                        print("Failed to create wine")
                    }
                }
            }
            
            // sets temp list of processed wines to the wine list of the model
            // sets unique list values
            DispatchQueue.main.async {
                        self.wines = tempWines
                        self.processUniqueValues()
            }
            
        } catch {
            print("Error reading file: \(error)")
        }
    }
    
    // parses the row correctly based on different "value types" that are supposed to be there for each column
    // ensures the lists for profile specifics, flavor profiles, and pairings stay together
    func parseCSVLine(_ line: String) -> [String] {
        var values: [String] = []
        var currentValue = ""
        var insideQuotes = false
            
        for char in line {
            if char == "," && !insideQuotes {
                values.append(currentValue.trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: .controlCharacters))
                currentValue = ""
            } else if char == "\"" {
                insideQuotes.toggle()
            } else {
                currentValue.append(char)
            }
        }
    
        values.append(currentValue.trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: .controlCharacters))
            
        return values
    }
    
    // converts the parsing of the wine row into a wine object
    func createWine(from dict: [String: Any]) -> Wine? {
        guard let vivinoLink = dict["Vivino Link"] as? String,
              let nameOnMenu = dict["Name (on menu)"] as? String,
              let restaurant = dict["Restaurant"] as? String,
              let glassPrice = Double(dict["Glass Price"] as! String),
              let bottlePrice = Double(dict["Bottle Price"] as! String),
              let winery = dict["Winery"] as? String,
              let wineStyle = dict["Wine Style"] as? String,
              let region = dict["Region"] as? String,
              let grapeVarieties = dict["Grape Varieties"] as? String,
              let abv = Double(dict["ABV"] as! String),
              let drySweet = Double(dict["Dry/Sweet"] as! String),
              let tannin = Double(dict["Tannin"] as! String),
              let softAcidic = Double(dict["Soft/Acidic"] as! String),
              let flavorProfileStr = dict["Flavor Profile"] as? String,
              let pairingsStr = dict["Pairings"] as? String,
              let rating = Double(dict["Rating"] as! String),
              let category = dict["Category"] as? String,
              let lightBold = Double(dict["Light/Bold"] as! String),
              let profileSpecificsStr = dict["Profile Specifics"] as? String,
              let fizziness = Double(dict["Fizziness"] as! String),
              let country = dict["Country"] as? String else {
            print("Missing or invalid fields in dictionary")
            return nil
        }

        let year = dict["Year"] as? String ?? ""

        return Wine(
            vivinoLink: vivinoLink,
            nameOnMenu: nameOnMenu,
            restaurant: restaurant,
            glassPrice: glassPrice,
            bottlePrice: bottlePrice,
            winery: winery,
            year: year,
            wineStyle: wineStyle,
            region: region,
            grapeVarieties: grapeVarieties,
            abv: abv,
            drySweet: drySweet,
            tannin: tannin,
            softAcidic: softAcidic,
            flavorProfile: convertToList(flavorProfileStr),
            pairings: convertToList(pairingsStr),
            rating: rating,
            category: category,
            lightBold: lightBold,
            profileSpecifics: convertToList(profileSpecificsStr),
            fizziness: fizziness,
            country: country
        )
    }
    
    // converts the columns with "lists" (profile specifics, flavor profiles, pairings) into a true list
    func convertToList(_ value: String?) -> [String] {
        guard let value = value, !value.isEmpty else {
            return []
        }
        
        return value.trimmingCharacters(in: .whitespacesAndNewlines)
                    .trimmingCharacters(in: CharacterSet(charactersIn: "'"))
                    .components(separatedBy: ",")
                    .map { $0.trimmingCharacters(in: .whitespaces) }
    }
    
    // creates the unique lists of different values for flavor columns (profiles, specifics, and pairings) as well as categories
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
