//
//  Wine.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/6/25.
//

import Foundation

class Wine {
    var vivinoLink: String
    var nameOnMenu: String
    var restaurant: String
    var glassPrice: Double
    var bottlePrice: Double
    var winery: String
    var year: String
    var wineStyle: String
    var region: String
    var grapeVarieties: String
    var abv: Double
    var drySweet: Double
    var tannin: Double
    var softAcidic: Double
    var flavorProfile: [String]
    var pairings: [String]
    var rating: Double
    var category: String
    var lightBold: Double
    var profileSpecifics: [String]
    var fizziness: Double
    var country: String
    
    init(vivinoLink: String, nameOnMenu: String, restaurant: String, glassPrice: Double, bottlePrice: Double, winery: String, year: String, wineStyle: String, region: String, grapeVarieties: String, abv: Double, drySweet: Double, tannin: Double, softAcidic: Double, flavorProfile: [String], pairings: [String], rating: Double, category: String, lightBold: Double, profileSpecifics: [String], fizziness: Double, country: String) {
        self.vivinoLink = vivinoLink
        self.nameOnMenu = nameOnMenu
        self.restaurant = restaurant
        self.glassPrice = glassPrice
        self.bottlePrice = bottlePrice
        self.winery = winery
        self.year = year
        self.wineStyle = wineStyle
        self.region = region
        self.grapeVarieties = grapeVarieties
        self.abv = abv
        self.drySweet = drySweet
        self.tannin = tannin
        self.softAcidic = softAcidic
        self.flavorProfile = flavorProfile
        self.pairings = pairings
        self.rating = rating
        self.category = category
        self.lightBold = lightBold
        self.profileSpecifics = profileSpecifics
        self.fizziness = fizziness
        self.country = country
    }
}

extension Wine: CustomStringConvertible {
    var description: String {
        return """
        Vivino Link: \(vivinoLink)
        Name on Menu: \(nameOnMenu)
        Restaurant: \(restaurant)
        Glass Price: \(glassPrice)
        Bottle Price: \(bottlePrice)
        Winery: \(winery)
        Year: \(year)
        Wine Style: \(wineStyle)
        Region: \(region)
        Grape Varieties: \(grapeVarieties)
        ABV: \(abv)%
        Dry/Sweet: \(drySweet)
        Tannin: \(tannin)
        Soft/Acidic: \(softAcidic)
        Flavor Profile: \(flavorProfile.joined(separator: ", "))
        Pairings: \(pairings.joined(separator: ", "))
        Rating: \(rating)
        Category: \(category)
        Light/Bold: \(lightBold)
        Profile Specifics: \(profileSpecifics.joined(separator: ", "))
        Fizziness: \(fizziness)
        Country: \(country)
        """
    }
}
