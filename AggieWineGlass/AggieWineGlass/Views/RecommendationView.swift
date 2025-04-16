//
//  RecommendationView.swift
//  AggieWineGlass
//
//  Created by Wild, Gabe on 4/16/25.
//
import SwiftUI

struct RecommendationView: View {
    @EnvironmentObject var preferences: UserPreferences
    @EnvironmentObject var wineDataInfo: WineDataInfo
    
    @StateObject var viewModel: RecommendationViewModel
    
    init(preferences: UserPreferences, wineDataInfo: WineDataInfo) {
        _viewModel = StateObject(wrappedValue:
            RecommendationViewModel (
                preferences: preferences,
                wineDataInfo: wineDataInfo
            )
        )
    }

    var body: some View {
        ZStack {
            Color("PrimaryColor").ignoresSafeArea()
            Text("🎉 You've completed all the swipes!")
                .font(.custom("Oswald-Regular", size: 24))
                .foregroundColor(.white)
        }
    }
}
