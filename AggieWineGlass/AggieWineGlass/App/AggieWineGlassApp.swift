//
//  AggieWineGlassApp.swift
//  AggieWineGlass
//
//  Created by Wild, Gabe on 4/2/25.
//

//
//  This is the main entry point into the app. All components will be called from here, and this will be the universal home for the App
//  See Example Files for Quick Tutorials and explanations to get up to speed on project structure
//
//  In order to run the App in the official simulator and view an execution as it plays out in the app, hit the play button on the left side bar (it builds, then runs [patience])
//  Make sure the Sim is set to an iPhone (At the top AggieWineGlass > IPhone, not mac)
//
//  The Preview Content is there so we can see the previews
//  The Assests file is how we define colors, pictures, logos etc. to be used in the app

import SwiftUI

@main
struct AggieWineGlassApp: App {
    @StateObject private var preferences = UserPreferences()
    @StateObject private var wineDataInfo = WineDataInfo()
    @State private var path = NavigationPath()

    private let wineViewModel: WineViewModel

    init() {
        let wineInfo = WineDataInfo()
        self._wineDataInfo = StateObject(wrappedValue: wineInfo)
        self.wineViewModel = WineViewModel(wineDataInfo: wineInfo)

        if let filePath = Bundle.main.path(forResource: "WineListData", ofType: "csv") {
            wineViewModel.loadWineData(filepath: filePath)
        } else {
            print("❌ WineListData.csv not found in bundle.")
        }
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                TitleView(path: $path)
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .title:
                            TitleView(path: $path)

                        case .categorySelection:
                            CategorySelectionView(
                                path: $path,
                                preferences: preferences,
                                wineDataInfo: wineDataInfo
                            )

                        case .sliderScales:
                            SliderScalesView(
                                path: $path,
                                preferences: preferences
                            )

                        case .regionSelection:
                            RegionSelectionView(
                                path: $path,
                                preferences: preferences,
                                wineDataInfo: wineDataInfo
                            )

                        case .flavorProfileSelection:
                            FlavorProfileSelectionView(
                                path: $path,
                                preferences: preferences,
                                wineDataInfo: wineDataInfo
                            )

                        case .pairingsSelection:
                            PairingsSelectionView(
                                path: $path,
                                preferences: preferences,
                                wineDataInfo: wineDataInfo
                            )

                        case .personalizationSelection:
                            PersonalizationSelectionView(
                                path: $path,
                                preferences: preferences
                            )

                        case .swipe:
                            SwipeView(
                                path: $path,
                                preferences: preferences,
                                wineDataInfo: wineDataInfo
                            )

                        case .recommendation:
                            RecommendationView(
                                path: $path,
                                preferences: preferences,
                                wineDataInfo: wineDataInfo
                            )
                        }
                    }
            }
            .environmentObject(preferences)
            .environmentObject(wineDataInfo)
            .accentColor(.white)
        }
    }
}

// Define your navigation routes
enum Route: Hashable {
    case title
    case categorySelection
    case sliderScales
    case regionSelection
    case flavorProfileSelection
    case pairingsSelection
    case personalizationSelection
    case swipe
    case recommendation
}
