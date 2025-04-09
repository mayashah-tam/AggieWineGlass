//
//  WineView.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/6/25.
//

import SwiftUI

struct WineView: View {
    @StateObject var viewModel = WineViewModel()
    
    @ObservedObject var wineDataInfo = WineDataInfo.shared

    var body: some View {
        VStack {
            if wineDataInfo.wines.isEmpty {
                Text("No wines available")
                    .padding()
            } else {
                List(wineDataInfo.wines, id: \.nameOnMenu) { wine in
                    VStack(alignment: .leading) {
                        Text("Name on Menu: \(wine.nameOnMenu)")
                            .font(.headline)
                        Text("Restaurant: \(wine.restaurant)")
                        Text("Winery: \(wine.winery)")
                        Text("Year: \(wine.year)")
                        Text("Wine Style: \(wine.wineStyle)")
                        Text("Region: \(wine.region)")
                        Text("Grape Varieties: \(wine.grapeVarieties)")
                        Text("ABV: \(wine.abv, specifier: "%.2f")%")
                        Text("Dry/Sweet: \(wine.drySweet, specifier: "%.2f")")
                        Text("Tannin: \(wine.tannin, specifier: "%.2f")")
                        Text("Soft/Acidic: \(wine.softAcidic, specifier: "%.2f")")
                        Text("Flavor Profile: \(wine.flavorProfile.joined(separator: ", "))")
                        Text("Profile Specifics: \(wine.profileSpecifics.joined(separator: ", "))")
                        Text("Pairings: \(wine.pairings.joined(separator: ", "))")
                        Text("Rating: \(wine.rating, specifier: "%.1f")")
                        Text("Category: \(wine.category)")
                        Text("Light/Bold: \(wine.lightBold, specifier: "%.2f")")
                        Text("Fizziness: \(wine.fizziness, specifier: "%.2f")")
                        Text("Country: \(wine.country)")
                        Text("Glass Price: $\(wine.glassPrice, specifier: "%.2f")")
                        Text("Bottle Price: $\(wine.bottlePrice, specifier: "%.2f")")
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            if let filePath = Bundle.main.path(forResource: "WineListData", ofType: "csv") {
                print("File path: \(filePath)")
                DispatchQueue.global(qos: .userInitiated).async {
                    viewModel.loadWineData(filepath: filePath)
                    DispatchQueue.main.async {
                        print("Wines loaded: \(wineDataInfo.wines.count)")
                    }
                }
            } else {
                print("File path is nil!")
            }
        }
    }
}
