//
//  SelectAllView.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/9/25.
//

import SwiftUI

struct CategorySelectionView: View {
    @StateObject var viewModel = CategorySelectionViewModel()

    // Observing the shared wine data info object to check when categories are ready
    @ObservedObject var wineDataInfo = WineDataInfo.shared

    // TODO -- fix the UI -- the functionality works, but the buttons don't actually check off
    var body: some View {
        VStack {
            Text("Select Categories:")
                .font(.headline)
                .padding()

            // Only show categories if they are loaded
            if wineDataInfo.uniqueCategories.isEmpty {
                Text("Loading categories...")
                    .padding()
            } else {
                // Display the unique categories from the singleton WineDataInfo shared instance
                List(wineDataInfo.uniqueCategories.sorted(), id: \.self) { category in
                    HStack {
                        // Custom checkbox-like toggle using a Button and Image
                        Button(action: {
                            viewModel.toggleCategorySelection(category: category)
                        }) {
                            HStack {
                                Image(systemName: viewModel.preferences.categories.contains(category) ? "checkmark.square" : "square")
                                    .foregroundColor(.blue) // Change the color as needed
                                Text(category)
                                    .foregroundColor(.primary)
                            }
                        }
                        .buttonStyle(PlainButtonStyle()) // Ensures no default button style interferes
                    }
                }

                // Button to select all categories
                Button(action: {
                    viewModel.selectAllCategories()
                }) {
                    Text("Select All Categories")
                        .foregroundColor(.blue)
                        .padding()
                }

                // Add a button to clear all selections if desired
                Button(action: {
                    viewModel.clearAllSelections()
                }) {
                    Text("Clear Selections")
                        .foregroundColor(.red)
                        .padding()
                }
            }
        }
        .padding()
        .onAppear {
            // Print the uniqueCategories when the view appears
            print("Unique Categories: \(wineDataInfo.uniqueCategories)")
        }
    }
}
