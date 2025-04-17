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

    @State private var recommendedWines: [Wine] = []
    @State private var expandedWineID: UUID?

    init(preferences: UserPreferences, wineDataInfo: WineDataInfo) {
        _viewModel = StateObject(wrappedValue:
            RecommendationViewModel(
                preferences: preferences,
                wineDataInfo: wineDataInfo
            )
        )
    }

    var body: some View {
        ZStack {
            Color("PrimaryColor").ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {
                Text("Our Recommendation")
                    .font(.custom("Oswald-Regular", size: 28))
                    .foregroundColor(.white)
                    .padding(.top, 30)
                    .padding(.horizontal)

//                ScrollView {
//                    VStack(spacing: 12) {
//                        ForEach(Array(recommendedWines.enumerated()), id: \.element.id) { index, wine in
//                            Button(action: {
//                                withAnimation(.easeInOut) {
//                                    expandedWineID = expandedWineID == wine.id ? nil : wine.id
//                                }
//                            }) {
////                                VStack(alignment: .leading, spacing: 8) {
////                                    HStack {
////                                        Text("#\(index + 1)")
////                                            .font(.headline)
////                                            .foregroundColor(.gray)
////
////                                        Text(wine.nameOnMenu)
////                                            .font(.custom("Oswald-Regular", size: 18))
////                                            .foregroundColor(.white)
////
////                                        Spacer()
////
////                                        Text("⭐️ \(String(format: "%.1f", wine.rating))")
////                                            .foregroundColor(.white)
////                                    }
////
////                                    if expandedWineID == wine.id {
////                                        VStack(alignment: .leading, spacing: 4) {
////                                            Text("Category: \(wine.category)")
////                                            Text("Price: $\(String(format: "%.2f", wine.price))")
////                                            Text("ABV: \(String(format: "%.1f", wine.abv))%")
////                                            Text("Tannin: \(wine.tannin, specifier: "%.1f")")
////                                            Text("Sweetness: \(wine.drySweet, specifier: "%.1f")")
////                                        }
////                                        .font(.footnote)
////                                        .foregroundColor(.white.opacity(0.9))
////                                        .padding(.top, 4)
////                                    }
////                                }
////                                .padding()
////                                .background(Color.white.opacity(0.05))
////                                .cornerRadius(12)
//                            }
//                            .buttonStyle(PlainButtonStyle())
//                            .padding(.horizontal)
//                        }
//                    }
//                    .padding(.top, 10)
//                }
            }
        }
        .onAppear {
            recommendedWines = viewModel.finalRecommendations(sortedWineScores: WineDataInfo.wines)
        }
    }
}
