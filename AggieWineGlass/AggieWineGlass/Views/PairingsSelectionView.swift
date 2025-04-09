//
//  PairingsSelectionView.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/9/25.
//

import SwiftUI

struct PairingsSelectionView: View {
    @StateObject var viewModel = PairingSelectionViewModel()

    // Observing the shared wine data info object to check when categories are ready
    @ObservedObject var wineDataInfo = WineDataInfo.shared
    
    
    @State private var showPairings = false  // State to track if categories should be shown

    var body: some View {
        VStack {
            Text("Select Food Pairings:")
                .font(.headline)
                .padding()

            // Display yes/no buttons to allow the user to choose if categories should be shown
            if !showPairings {
                HStack {
                    Button(action: {
                        // User clicked Yes, show the categories
                        viewModel.turnOnPairingSelection()
                        viewModel.findPairingsBasedOnWineCategories()
                        showPairings = true
                    }) {
                        Text("Yes")
                            .foregroundColor(.blue)
                            .padding()
                    }

                    Button(action: {
                        // User clicked No, do not show the categories
                        showPairings = false
                    }) {
                        Text("No")
                            .foregroundColor(.red)
                            .padding()
                    }
                }
            }

            // Only show pairings if showPairings is true
            if showPairings {
                // Only show categories if they are loaded
                if viewModel.uniqueFilteredPairings.isEmpty {
                    Text("Loading pairings...")
                        .padding()
                        .foregroundColor(.gray) // Optional: Make the loading text a different color
                } else {
                    // note that this is currently loading all the pairings ... we need to map this based on the categories of wines they selected (i.e. don't display desert pairing if they didn't select desert wines as a category
                    List(viewModel.uniqueFilteredPairings.sorted(), id: \.self) { pairing in
                        HStack {
                            // Custom checkbox-like toggle using a Button and Image
                            Button(action: {
                                viewModel.togglePairingSelection(pairing: pairing)
                            }) {
                                HStack {
                                    Image(systemName: viewModel.preferences.pairings.contains(pairing) ? "checkmark.square" : "square")
                                        .foregroundColor(.blue) // Change the color as needed
                                    Text(pairing)
                                        .foregroundColor(.primary)
                                }
                            }
                            .buttonStyle(PlainButtonStyle()) // Ensures no default button style interferes
                        }
                    }

                    // Button to select all categories
                    Button(action: {
                        viewModel.selectAllPairings()
                    }) {
                        Text("Select All Pairings")
                            .foregroundColor(.blue)
                            .padding()
                    }

                    // Add a button to clear all selections if desired
                    Button(action: {
                        viewModel.clearAllPairings()
                    }) {
                        Text("Clear Pairings")
                            .foregroundColor(.red)
                            .padding()
                    }
                }
            }
        }
        .padding()
        .onAppear {
            // Print the uniqueCategories when the view appears
            print("Unique Pairings: \(wineDataInfo.uniquePairings)")
        }
    }
}

