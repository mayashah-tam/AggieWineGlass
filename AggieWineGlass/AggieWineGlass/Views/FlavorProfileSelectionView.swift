//
//  FlavorProfileSelectionView.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/9/25.
//
import SwiftUI

struct FlavorProfileSelectionView: View {
    @Binding var path: NavigationPath
    @EnvironmentObject var preferences: UserPreferences
    @EnvironmentObject var wineDataInfo: WineDataInfo

    @StateObject private var viewModel: FlavorProfileSelectionViewModel
    @State private var showAlert = false

    init(path: Binding<NavigationPath>, preferences: UserPreferences, wineDataInfo: WineDataInfo) {
        self._path = path
        self._viewModel = StateObject(wrappedValue:
            FlavorProfileSelectionViewModel(
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
                SectionTitleView(text: "Select Flavor Profiles")
                Spacer()

                if wineDataInfo.uniqueFlavorProfiles.isEmpty {
                    Text("Loading flavor profiles...")
                        .foregroundColor(.white)
                        .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(wineDataInfo.uniqueFlavorProfiles.sorted(), id: \.self) { flavor in
                                let isSelected = preferences.flavorProfiles.contains(flavor)

                                Button(action: {
                                    viewModel.toggleFlavorProfileSelection(flavorProfile: flavor)
                                }) {
                                    VStack {
                                        Image(flavor)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 80, height: 80)

                                        Text(flavor.replacingOccurrences(of: "_", with: " ").capitalized)
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .padding(.top, 4)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
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
                    .frame(maxHeight: UIScreen.main.bounds.height * 0.7)
                }

                HStack(spacing: 16) {
                    Button(action: {
                        viewModel.selectAllFlavorProfiles()
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
                        viewModel.clearAllFlavorProfiles()
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

                Spacer()

                Button(action: {
                    viewModel.setProfileSpecifics()
                    if preferences.flavorSpecifics.isEmpty {
                        showAlert = true
                    } else {
                        withAnimation {
                            path.append(Route.pairingsSelection)
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
                .alert("Please select at least one flavor profile", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                }
                .padding(.top, 20)
            }
            .padding()
        }
        .onAppear {
            print("Unique Flavor Profiles: \(wineDataInfo.uniqueFlavorProfiles)")
        }
    }
}

