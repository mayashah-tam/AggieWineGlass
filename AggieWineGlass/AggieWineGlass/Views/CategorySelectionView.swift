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
    @State private var showAlert = false

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
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]

        ZStack {
            Color("PrimaryColor").ignoresSafeArea()

            VStack(spacing: 20) {
                SectionTitleView(text: "Select Categories")

                if wineDataInfo.uniqueCategories.isEmpty {
                    Text("Loading categories...")
                        .foregroundColor(.white)
                        .padding()
                } else {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(wineDataInfo.uniqueCategories.sorted(), id: \.self) { category in
                            let isSelected = preferences.categories.contains(category)

                            Button(action: {
                                viewModel.toggleCategorySelection(category: category)
                            }) {
                                VStack {
                                    Image(category.capitalized)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)

                                    Text(category.capitalized)
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
                            viewModel.selectAllCategories()
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
                            viewModel.clearAllSelections()
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

                    Button(action: {
                        if preferences.categories.isEmpty {
                            showAlert = true
                        } else {
                            showSliderScales = true
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
                    .alert("Please select at least one category", isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    }
                    .padding(.top, 20)
                }
            }
            .padding()
        }
        .onAppear {
            print("Unique Categories: \(wineDataInfo.uniqueCategories)")
        }
        .navigationDestination(isPresented: $showSliderScales) {
            SliderScalesView(preferences: preferences)
        }
    }
}
