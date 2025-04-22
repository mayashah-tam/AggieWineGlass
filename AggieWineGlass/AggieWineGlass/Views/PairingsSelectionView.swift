//
//  PairingsSelectionView.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/9/25.
//

import SwiftUI

struct PairingsSelectionView: View {
    @Binding var path: NavigationPath
    @EnvironmentObject var preferences: UserPreferences
    @EnvironmentObject var wineDataInfo: WineDataInfo

    @StateObject private var viewModel: PairingSelectionViewModel
    @State private var showPairings = false
    @State private var selection: String = "No"
    @State private var showAlert = false

    init(path: Binding<NavigationPath>, preferences: UserPreferences, wineDataInfo: WineDataInfo) {
        self._path = path
        self._viewModel = StateObject(wrappedValue:
            PairingSelectionViewModel(
                preferences: preferences,
                wineDataInfo: wineDataInfo
            )
        )
    }

    var body: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]

        ZStack {
            Color("PrimaryColor").ignoresSafeArea()

            VStack(spacing: 20) {
                SectionTitleView(text: "Select Food Pairings")
                Spacer()

                HStack(spacing: 0) {
                    ForEach(["Yes", "No"], id: \.self) { option in
                        Button(action: {
                            selection = option
                            if option == "Yes" {
                                viewModel.turnOnPairingSelection()
                                viewModel.findPairingsBasedOnWineCategories()
                                showPairings = true
                            } else {
                                showPairings = false
                                preferences.isPairing = false
                                viewModel.clearAllPairings()
                            }
                        }) {
                            Text(option)
                                .font(.custom("Oswald-Regular", size: 16))
                                .foregroundColor(selection == option ? Color("PrimaryColor") : .white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 6)
                                .background(selection == option ? Color.white : Color.clear)
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white, lineWidth: 2)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)

                Group {
                    if showPairings {
                        if viewModel.uniqueFilteredPairings.isEmpty {
                            Text("Loading pairings...")
                                .foregroundColor(.white)
                                .frame(maxHeight: UIScreen.main.bounds.height * 0.7)
                        } else {
                            ScrollView {
                                LazyVGrid(columns: columns, spacing: 20) {
                                    ForEach(viewModel.uniqueFilteredPairings.sorted(), id: \.self) { pairing in
                                        let isSelected = preferences.pairings.contains(pairing)

                                        Button(action: {
                                            viewModel.togglePairingSelection(pairing: pairing)
                                        }) {
                                            VStack {
                                                Image(pairing)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 80, height: 80)

                                                Text(pairing.replacingOccurrences(of: "_", with: " ").capitalized)
                                                    .font(.caption)
                                                    .foregroundColor(.white)
                                                    .multilineTextAlignment(.center)
                                                    .padding(.top, 4)
                                                    .fixedSize(horizontal: false, vertical: true)
                                            }
                                            .padding()
                                            .frame(maxWidth: .infinity, minHeight: 160, maxHeight: 160)
                                            .background(isSelected ? Color.white.opacity(0.2) : Color.clear)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.white, lineWidth: 1)
                                            )
                                            .cornerRadius(12)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.top)
                            }
                            .frame(height: UIScreen.main.bounds.height * 0.415)

                            HStack(spacing: 16) {
                                Button(action: {
                                    viewModel.selectAllPairings()
                                }) {
                                    Text("Select All")
                                        .font(.custom("Oswald-Regular", size: 16))
                                        .foregroundColor(Color("PrimaryColor"))
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                }

                                Button(action: {
                                    viewModel.clearAllPairings()
                                }) {
                                    Text("Clear All")
                                        .font(.custom("Oswald-Regular", size: 16))
                                        .foregroundColor(Color("PrimaryColor"))
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                }
                            }
                            .padding(.top, 10)
                        }
                    } else {
                        Spacer()
                            .frame(height: UIScreen.main.bounds.height * 0.5)
                    }
                }

                Spacer()

                Button(action: {
                    if preferences.isPairing {
                        if preferences.pairings.isEmpty {
                            showAlert = true
                        } else {
                            withAnimation {
                                path.append(Route.personalizationSelection)
                            }
                        }
                    } else {
                        withAnimation {
                            path.append(Route.personalizationSelection)
                        }
                    }
                }) {
                    Text("Next")
                        .font(.custom("Oswald-Regular", size: 18))
                        .foregroundColor(Color("PrimaryColor"))
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .cornerRadius(12)
                }
                .padding(.top, 20)
                .alert("Please select at least one pairing", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                }
            }
            .padding()
        }
        .onAppear {
            print("Unique Pairings: \(wineDataInfo.uniquePairings)")
        }
    }
}
