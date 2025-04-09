//
//  FlavorProfileSelectionView.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/9/25.
//

import SwiftUI

struct FlavorProfileSelectionView: View {
    @StateObject var viewModel = FlavorProfileSelectionModel()

    // Observing the shared wine data info object to check when categories are ready
    @ObservedObject var wineDataInfo = WineDataInfo.shared

    // TODO -- fix the UI -- the functionality works, but the buttons don't actually check off
    var body: some View {
        VStack {
            Text("Select Flavor Profiles:")
                .font(.headline)
                .padding()

            // Only show categories if they are loaded
            if wineDataInfo.uniqueFlavorProfiles.isEmpty {
                Text("Loading categories...")
                    .padding()
            } else {
                // Display the unique categories from the singleton WineDataInfo shared instance
                List(wineDataInfo.uniqueFlavorProfiles.sorted(), id: \.self) { flavorProfile in
                    HStack {
                        // Custom checkbox-like toggle using a Button and Image
                        Button(action: {
                            viewModel.toggleFlavorProfileSelection(flavorProfile: flavorProfile)
                        }) {
                            HStack {
                                Image(systemName: viewModel.preferences.flavorProfiles.contains(flavorProfile) ? "checkmark.square" : "square")
                                    .foregroundColor(.blue) // Change the color as needed
                                Text(flavorProfile)
                                    .foregroundColor(.primary)
                            }
                        }
                        .buttonStyle(PlainButtonStyle()) // Ensures no default button style interferes
                    }
                }

                // Button to select all categories
                Button(action: {
                    viewModel.selectAllFlavorProfiles()
                }) {
                    Text("Select All Flavor Profiles")
                        .foregroundColor(.blue)
                        .padding()
                }

                // Add a button to clear all selections if desired
                Button(action: {
                    viewModel.clearAllFlavorProfiles()
                }) {
                    Text("Clear All Flavor Profules")
                        .foregroundColor(.red)
                        .padding()
                }
            }
        }
        .padding()
        .onAppear {
            // Print the uniqueCategories when the view appears
            print("Unique Flavor Profiles: \(wineDataInfo.uniqueFlavorProfiles)")
        }
    }
}
