//
//  SwipeSetView.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/12/25.
//

import SwiftUICore
import SwiftUI

struct SwipeSetView: View {
    
    @EnvironmentObject var preferences: UserPreferences
    @EnvironmentObject var wineDataInfo: WineDataInfo
    
    @StateObject private var viewModel: SwipeSetViewModel
    @StateObject private var viewModel2: RecommendationViewModel
    
    init(preferences: UserPreferences, wineDataInfo: WineDataInfo) {
        _viewModel = StateObject(wrappedValue:
            SwipeSetViewModel(
                preferences: preferences,
                wineDataInfo: wineDataInfo
            )
        )
        _viewModel2 = StateObject(wrappedValue: RecommendationViewModel(preferences: preferences, wineDataInfo: wineDataInfo))
    }
    
    var body: some View {
        VStack {
            Text("Testing for SwipeSet")
                .font(.headline)
                .padding()

                .onAppear() {
                    // viewModel.setSwipeSets()
                    //viewModel.wineCBF(filterCategories: ["Red wine"])
                    //viewModel.findScaleWineRandom(filterCategories: ["Red wine"])
                    //viewModel.findFlavorWineRandom(filterCategories: ["Red wine"])
                    //viewModel.createMiniSet(filterCategory: "Red wine")
                    //viewModel2.recommendationRanking()
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
    }
}
