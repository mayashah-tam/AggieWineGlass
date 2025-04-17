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
    @State private var expandedWineID: String?

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
                SectionTitleView(text: "Our Recommendation")

                Spacer()

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(Array(recommendedWines.enumerated()), id: \.element.id) { index, wine in
                            WineCardView(wine: wine, index: index, expandedWineID: $expandedWineID)
                        }
                    }
                    .padding(.top, 10)
                }
            }
        }
        .onAppear {
            recommendedWines = viewModel.finalRecommendations()
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct WineCardView: View {
    @EnvironmentObject var preferences: UserPreferences
    
    let wine: Wine
    let index: Int
    @Binding var expandedWineID: String?

    var isExpanded: Bool {
        expandedWineID == wine.id
    }

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut) {
                expandedWineID = isExpanded ? nil : wine.id
            }
        }) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 10) {
                    Text("\(index + 1)")
                        .font(.headline)
                        .foregroundColor(.white)

                    Image(wine.category.capitalized)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)

                    Text(wine.nameOnMenu.capitalized)
                        .font(.custom("Oswald-Regular", size: 18))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    Spacer()

                    Text("⭐️ \(String(format: "%.1f", wine.rating))")
                        .foregroundColor(.white)
                }

                if isExpanded {
                    VStack(alignment: .leading, spacing: 12) {
                        // MARK: - Location
                        Text("Located At")
                            .font(.custom("Oswald-Regular", size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .center)

                        HStack {
                            Text(wine.restaurant)
                            Spacer()
                            Text("$\(String(format: "%.2f", wine.glassPrice)) / glass")
                        }
                        .font(.subheadline)
                        .foregroundColor(.white)

                        // MARK: - Info
                        Text("Wine Information")
                            .font(.custom("Oswald-Regular", size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .center)

                        VStack(alignment: .leading, spacing: 6) {
                            wineInfoRow(label: "Country", value: wine.country)
                            wineInfoRow(label: "Region", value: wine.region)
                            wineInfoRow(label: "Winery", value: wine.winery)
                            wineInfoRow(label: "Grapes", value: cleanGrapeString(wine.grapeVarieties))
                            wineInfoRow(label: "Bottle Price", value: "$\(String(format: "%.2f", wine.bottlePrice))")
                        }

                        .font(.subheadline)
                        .foregroundColor(.white)

                        // MARK: - Attributes
                        Text("Attributes")
                            .font(.custom("Oswald-Regular", size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .center)

                        VStack(alignment: .leading, spacing: 10) {
                            WineAttributeSlider(title: "Dry/Sweet", value: wine.drySweet, min: 1, max: 5, color: .white)
                            WineAttributeSlider(title: "Tannin", value: wine.tannin, min: 1, max: 5, color: .white)
                            WineAttributeSlider(title: "Soft/Acidic", value: wine.softAcidic, min: 1, max: 5, color: .white)
                            WineAttributeSlider(title: "Light/Bold", value: wine.lightBold, min: 1, max: 5, color: .white)
                            WineAttributeSlider(title: "Fizziness", value: wine.fizziness, min: 0, max: 5, color: .white)
                        }

                        // MARK: - Profile Highlights
                        Text("Profile Highlights")
                            .font(.custom("Oswald-Regular", size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .center)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 5), spacing: 12) {
                            ForEach(wine.profileSpecifics.prefix(5), id: \.self) { profile in
                                VStack(spacing: 4) {
                                    Image(profile)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)

                                    Text(profile.replacingOccurrences(of: "_", with: " ").capitalized)
                                        .font(.caption2)
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                        .minimumScaleFactor(0.7)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        
                        // MARK: - Pairings
                        if preferences.isPairing, !wine.pairings.isEmpty {
                            Text("Pairings")
                                .font(.custom("Oswald-Regular", size: 16))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .center)

                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: min(wine.pairings.count, 5)), spacing: 12) {
                                ForEach(wine.pairings.prefix(5), id: \.self) { pairing in
                                    VStack(spacing: 4) {
                                        Image(pairing)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40)

                                        Text(pairing.replacingOccurrences(of: "_", with: " ").capitalized)
                                            .font(.caption2)
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                            .lineLimit(2)
                                            .minimumScaleFactor(0.7)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                        }
                    }
                    .padding(.top, 6)
                }

            }
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
    }
}

@ViewBuilder
private func wineInfoRow(label: String, value: String) -> some View {
    HStack {
        Text(label)
            .foregroundColor(.white)
            .font(.subheadline)

        Spacer()

        Text(value)
            .foregroundColor(.white)
            .font(.subheadline)
            .multilineTextAlignment(.trailing)
    }
}

private func cleanGrapeString(_ raw: String) -> String {
    raw
        .replacingOccurrences(of: "[", with: "")
        .replacingOccurrences(of: "]", with: "")
        .replacingOccurrences(of: "'", with: "")
        .trimmingCharacters(in: .whitespacesAndNewlines)
}

