//
//  CategorySelectionView.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/8/25.
//

import SwiftUI

struct CategorySelectionView: View {
    @EnvironmentObject var preferences: UserPreferences
    @EnvironmentObject var wineDataInfo: WineDataInfo

    @StateObject private var viewModel: CategorySelectionViewModel
    @State private var showSliderScales = false

    init(preferences: UserPreferences, wineDataInfo: WineDataInfo) {
        _viewModel = StateObject(wrappedValue:
            CategorySelectionViewModel(
                preferences: preferences,
                wineDataInfo: wineDataInfo
            )
        )
    }

    var body: some View {
        VStack {
            Text("Select Categories:")
                .font(.headline)
                .padding()

            if wineDataInfo.uniqueCategories.isEmpty {
                Text("Loading categories...")
                    .padding()
            } else {
                List(wineDataInfo.uniqueCategories.sorted(), id: \.self) { category in
                    Button(action: {
                        viewModel.toggleCategorySelection(category: category)
                    }) {
                        HStack {
                            Image(systemName: preferences.categories.contains(category) ? "checkmark.square" : "square")
                                .foregroundColor(.blue)
                            Text(category)
                                .foregroundColor(.primary)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                Button("Select All Categories") {
                    viewModel.selectAllCategories()
                }
                .foregroundColor(.blue)
                .padding()

                Button("Clear Selections") {
                    viewModel.clearAllSelections()
                }
                .foregroundColor(.red)
                .padding()

                Button("Next") {
                    showSliderScales = true
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
            print("Unique Categories: \(wineDataInfo.uniqueCategories)")
        }
        .navigationDestination(isPresented: $showSliderScales) {
            SliderScalesView(
                preferences: preferences
            )
        }
    }
}
