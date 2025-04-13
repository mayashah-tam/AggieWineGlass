//
//  PersonalizataionSelectionView.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/9/25.
//

import SwiftUI

struct PersonalizationSelectionView: View {
    @EnvironmentObject var preferences: UserPreferences
    @EnvironmentObject var wineDataInfo: WineDataInfo

    @StateObject private var viewModel: PersonalizationSelectionViewModel
    @State private var showSwipeSetView = false

    init(preferences: UserPreferences) {
        _viewModel = StateObject(wrappedValue:
            PersonalizationSelectionViewModel(
                preferences: preferences
            )
        )
    }

    var body: some View {
        VStack {
            Text("Do you want more or less personalization?")
                .font(.headline)
                .padding()

            HStack {
                Button("More") {
                    viewModel.turnOnMorePersonalization()
                }
                .foregroundColor(.blue)
                .padding()

                Button("Less") {
                    viewModel.turnOffMorePersonalization()
                }
                .foregroundColor(.red)
                .padding()
            }

            Button("Next") {
                showSwipeSetView = true
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
        .navigationDestination(isPresented: $showSwipeSetView) {
            SwipeSetView(preferences: preferences, wineDataInfo: wineDataInfo)
        }
    }
}
