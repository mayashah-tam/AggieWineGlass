//
//  SliderScalesView.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/8/25.
//

import SwiftUI

struct SliderScalesView: View {
    @Binding var path: NavigationPath
    @EnvironmentObject var preferences: UserPreferences
    @EnvironmentObject var wineDataInfo: WineDataInfo

    @StateObject private var viewModel: SliderScalesViewModel

    init(path: Binding<NavigationPath>, preferences: UserPreferences) {
        _viewModel = StateObject(wrappedValue:
            SliderScalesViewModel(
                preferences: preferences
            )
        )
        self._path = path
    }

    var body: some View {
        ZStack {
            Color("PrimaryColor").ignoresSafeArea()

            VStack(spacing: 20) {
                SectionTitleView(text: "Adjust Your Taste Preferences")
                
                Spacer()

                Group {
                    SliderView(
                        value: $viewModel.preferences.drySweetScale,
                        label: "Dry/Sweet",
                        range: 1...5,
                        update: viewModel.updateDrySweetScale
                    )

                    SliderView(
                        value: $viewModel.preferences.tanninScale,
                        label: "Tannin",
                        range: 1...5,
                        update: viewModel.updateTanninScale
                    )

                    SliderView(
                        value: $viewModel.preferences.softAcidityScale,
                        label: "Acidity",
                        range: 1...5,
                        update: viewModel.updateSoftAcidityScale
                    )

                    SliderView(
                        value: $viewModel.preferences.lightBoldScale,
                        label: "Light/Bold",
                        range: 1...5,
                        update: viewModel.updateLightBoldScale
                    )

                    SliderView(
                        value: $viewModel.preferences.fizzinessScale,
                        label: "Fizziness",
                        range: 0...5,
                        update: viewModel.updateFizzinessScale
                    )
                }
                
                Spacer()

                Button(action: {
                    withAnimation {
                        path.append(Route.regionSelection)
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
                .padding(.top, 20)
            }
        }
        .onAppear {
            viewModel.updateDrySweetScale()
            viewModel.updateTanninScale()
            viewModel.updateSoftAcidityScale()
            viewModel.updateLightBoldScale()
            viewModel.updateFizzinessScale()
        }
    }
}

private struct SliderView: View {
    @Binding var value: Double
    var label: String
    var range: ClosedRange<Double>
    var update: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(label): \(Int(value))")
                .foregroundColor(.white)
                .font(.headline)

            Slider(value: $value, in: range, step: 1)
                .accentColor(.white)
                .onChange(of: value) {
                    update()
                }
        }
        .padding(.horizontal)
    }
}
