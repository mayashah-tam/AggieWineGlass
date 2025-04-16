import SwiftUI

struct RegionsSelectionView: View {
    @EnvironmentObject var preferences: UserPreferences
    @EnvironmentObject var wineDataInfo: WineDataInfo

    @StateObject private var viewModel: RegionSelectionViewModel
    @State private var showFlavorProfileSelection = false
    @State private var showAlert = false

    init(preferences: UserPreferences, wineDataInfo: WineDataInfo) {
        _viewModel = StateObject(wrappedValue:
            RegionSelectionViewModel(
                preferences: preferences,
                wineDataInfo: wineDataInfo
            )
        )
    }

    var body: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]

        ZStack {
            Color("PrimaryColor").ignoresSafeArea()

            VStack(spacing: 20) {
                SectionTitleView(text: "Select Regions")
                
                Spacer()
                Spacer()

                if wineDataInfo.uniqueRegionClasses.isEmpty {
                    Text("Loading regions...")
                        .foregroundColor(.white)
                        .padding()
                } else {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(wineDataInfo.uniqueRegionClasses.sorted(), id: \.self) { region in
                            let isSelected = preferences.regionClasses.contains(region)

                            Button(action: {
                                viewModel.toggleRegionSelection(region: region)
                            }) {
                                VStack {
                                    Image(region)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 100)

                                    Text(region)
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

                    HStack(spacing: 16) {
                        Button(action: {
                            viewModel.selectAllRegions()
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
                            viewModel.clearAllRegions()
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
                    Spacer()

                    Button(action: {
                        if preferences.regionClasses.isEmpty {
                            showAlert = true
                        } else {
                            showFlavorProfileSelection = true
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
                    .alert("Please select at least one region", isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            print("Unique Regions: \(wineDataInfo.uniqueRegionClasses)")
        }
        .navigationDestination(isPresented: $showFlavorProfileSelection) {
            FlavorProfileSelectionView(
                preferences: preferences,
                wineDataInfo: wineDataInfo
            )
        }
    }
}

