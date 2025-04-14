//
//  FlavorProfileSelectionView.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/9/25.
//

import SwiftUI

struct FlavorProfileSelectionView: View {
    @EnvironmentObject var preferences: UserPreferences
    @EnvironmentObject var wineDataInfo: WineDataInfo

    @StateObject private var viewModel: FlavorProfileSelectionViewModel
    @State private var showRegionsSelection = false

    init(preferences: UserPreferences, wineDataInfo: WineDataInfo) {
        _viewModel = StateObject(wrappedValue:
            FlavorProfileSelectionViewModel(
                preferences: preferences,
                wineDataInfo: wineDataInfo
            )
        )
    }

    var body: some View {
        VStack {
            Text("Select Flavor Profiles:")
                .font(.headline)
                .padding()

            if wineDataInfo.uniqueFlavorProfiles.isEmpty {
                Text("Loading flavor profiles...")
                    .padding()
            } else {
                List(wineDataInfo.uniqueFlavorProfiles.sorted(), id: \.self) { flavorProfile in
                    Button(action: {
                        viewModel.toggleFlavorProfileSelection(flavorProfile: flavorProfile)
                    }) {
                        HStack {
                            Image(systemName: viewModel.preferences.flavorProfiles.contains(flavorProfile) ? "checkmark.square" : "square")
                                .foregroundColor(.blue)
                            Text(flavorProfile)
                                .foregroundColor(.primary)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                Button("Select All Flavor Profiles") {
                    viewModel.selectAllFlavorProfiles()
                }
                .foregroundColor(.blue)
                .padding()

                Button("Clear All Flavor Profiles") {
                    viewModel.clearAllFlavorProfiles()
                }
                .foregroundColor(.red)
                .padding()

                Button("Next") {
                    viewModel.setProfileSpecifics()
                    showRegionsSelection = true
                }
                .font(.title2)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.top)
            }
        }
        .padding()
        .onAppear {
            print("Unique Flavor Profiles: \(wineDataInfo.uniqueFlavorProfiles)")
        }
        .navigationDestination(isPresented: $showRegionsSelection) {
            RegionsSelectionView(
                preferences: preferences,
                wineDataInfo: wineDataInfo
            )
        }
    }
}
