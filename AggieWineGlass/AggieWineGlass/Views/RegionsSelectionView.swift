//
//  RegionsSelectionView.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/9/25.
//

import SwiftUI

struct RegionsSelectionView: View {
    @StateObject var viewModel = RegionSelectionViewModel()

    // Observing the shared wine data info object to check when categories are ready
    @ObservedObject var wineDataInfo = WineDataInfo.shared

    // TODO -- fix the UI -- the functionality works, but the buttons don't actually check off
    var body: some View {
        VStack {
            Text("Select Regions")
                .font(.headline)
                .padding()

            // Only show categories if they are loaded
            if wineDataInfo.uniqueRegionClasses.isEmpty {
                Text("Loading regions...")
                    .padding()
            } else {
                // Display the unique categories from the singleton WineDataInfo shared instance
                List(wineDataInfo.uniqueRegionClasses.sorted(), id: \.self) { region in
                    HStack {
                        // Custom checkbox-like toggle using a Button and Image
                        Button(action: {
                            viewModel.toggleRegionSelection(region: region)
                        }) {
                            HStack {
                                Image(systemName: viewModel.preferences.regionClasses.contains(region) ? "checkmark.square" : "square")
                                    .foregroundColor(.blue) // Change the color as needed
                                Text(region)
                                    .foregroundColor(.primary)
                            }
                        }
                        .buttonStyle(PlainButtonStyle()) // Ensures no default button style interferes
                    }
                }

                // Button to select all categories
                Button(action: {
                    viewModel.selectAllRegions()
                }) {
                    Text("Select All Regions")
                        .foregroundColor(.blue)
                        .padding()
                }

                // Add a button to clear all selections if desired
                Button(action: {
                    viewModel.clearAllRegions()
                }) {
                    Text("Clear All Regions")
                        .foregroundColor(.red)
                        .padding()
                }
            }
        }
        .padding()
        .onAppear {
            // Print the uniqueCategories when the view appears
            print("Unique Regions: \(wineDataInfo.uniqueRegionClasses)")
        }
    }
}
