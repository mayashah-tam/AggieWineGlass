//
//  PairingsSelectionView.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/9/25.
//

import SwiftUI

struct PairingsSelectionView: View {
    @EnvironmentObject var preferences: UserPreferences
    @EnvironmentObject var wineDataInfo: WineDataInfo

    @StateObject private var viewModel: PairingSelectionViewModel
    @State private var showPairings = false
    @State private var showFlavorProfileSelection = false

    init(preferences: UserPreferences, wineDataInfo: WineDataInfo) {
        _viewModel = StateObject(wrappedValue:
            PairingSelectionViewModel(
                preferences: preferences,
                wineDataInfo: wineDataInfo
            )
        )
    }

    var body: some View {
        VStack {
            Text("Select Food Pairings:")
                .font(.headline)
                .padding()

            if !showPairings {
                HStack {
                    Button(action: {
                        viewModel.turnOnPairingSelection()
                        viewModel.findPairingsBasedOnWineCategories()
                        showPairings = true
                    }) {
                        Text("Yes")
                            .foregroundColor(.blue)
                            .padding()
                    }

                    Button(action: {
                        showPairings = false
                    }) {
                        Text("No")
                            .foregroundColor(.red)
                            .padding()
                    }
                }
            }

            if showPairings {
                if viewModel.uniqueFilteredPairings.isEmpty {
                    Text("Loading pairings...")
                        .padding()
                        .foregroundColor(.gray)
                } else {
                    List(viewModel.uniqueFilteredPairings.sorted(), id: \.self) { pairing in
                        Button(action: {
                            viewModel.togglePairingSelection(pairing: pairing)
                        }) {
                            HStack {
                                Image(systemName: viewModel.preferences.pairings.contains(pairing) ? "checkmark.square" : "square")
                                    .foregroundColor(.blue)
                                Text(pairing)
                                    .foregroundColor(.primary)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }

                    Button("Select All Pairings") {
                        viewModel.selectAllPairings()
                    }
                    .foregroundColor(.blue)
                    .padding()

                    Button("Clear Pairings") {
                        viewModel.clearAllPairings()
                    }
                    .foregroundColor(.red)
                    .padding()
                }
            }

            Button("Next") {
                showFlavorProfileSelection = true
            }
            .font(.title2)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.top)
        }
        .padding()
        .onAppear {
            print("Unique Pairings: \(wineDataInfo.uniquePairings)")
        }
        .navigationDestination(isPresented: $showFlavorProfileSelection) {
            FlavorProfileSelectionView(
                preferences: preferences,
                wineDataInfo: wineDataInfo
            )
        }
    }
}
