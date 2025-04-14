import SwiftUI

struct RegionsSelectionView: View {
    @EnvironmentObject var preferences: UserPreferences
    @EnvironmentObject var wineDataInfo: WineDataInfo

    @StateObject private var viewModel: RegionSelectionViewModel
    @State private var showPersonalizationSelection = false

    init(preferences: UserPreferences, wineDataInfo: WineDataInfo) {
        _viewModel = StateObject(wrappedValue:
            RegionSelectionViewModel(
                preferences: preferences,
                wineDataInfo: wineDataInfo
            )
        )
    }

    var body: some View {
        VStack {
            Text("Select Regions")
                .font(.headline)
                .padding()

            if wineDataInfo.uniqueRegionClasses.isEmpty {
                Text("Loading regions...")
                    .padding()
            } else {
                List(wineDataInfo.uniqueRegionClasses.sorted(), id: \.self) { region in
                    Button(action: {
                        viewModel.toggleRegionSelection(region: region)
                    }) {
                        HStack {
                            Image(systemName: viewModel.preferences.regionClasses.contains(region) ? "checkmark.square" : "square")
                                .foregroundColor(.blue)
                            Text(region)
                                .foregroundColor(.primary)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                Button("Select All Regions") {
                    viewModel.selectAllRegions()
                }
                .foregroundColor(.blue)
                .padding()

                Button("Clear All Regions") {
                    viewModel.clearAllRegions()
                }
                .foregroundColor(.red)
                .padding()

                Button("Next") {
                    showPersonalizationSelection = true
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
            print("Unique Regions: \(wineDataInfo.uniqueRegionClasses)")
        }
        .navigationDestination(isPresented: $showPersonalizationSelection) {
            PersonalizationSelectionView(
                preferences: preferences
            )
        }
    }
}
