//
//  SliderScalesView.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/8/25.
//

import SwiftUI

struct SliderScalesView: View {
    @StateObject var viewModel = SliderScalesViewModel()

    var body: some View {
        VStack {
            Slider(value: $viewModel.preferences.drySweetScale, in: 1...5, step: 1)
                    .padding()
                    .onChange(of: viewModel.preferences.drySweetScale) {
                        viewModel.updateDrySweetScale()
                    }
            Text("Dry/Sweet Scale: \(Int(viewModel.preferences.drySweetScale))")
                
            Slider(value: $viewModel.preferences.tanninScale, in: 1...5, step: 1)
                .padding()
                .onChange(of: viewModel.preferences.tanninScale) {
                    viewModel.updateTanninScale()
                }
            Text("Tannin Scale: \(Int(viewModel.preferences.tanninScale))")
                
            Slider(value: $viewModel.preferences.softAcidityScale, in: 1...5, step: 1)
                .padding()
                .onChange(of: viewModel.preferences.softAcidityScale) {
                    viewModel.updateSoftAcidityScale()
                }
            Text("Soft Acidity Scale: \(Int(viewModel.preferences.softAcidityScale))")
                
            Slider(value: $viewModel.preferences.lightBoldScale, in: 1...5, step: 1)
                .padding()
                .onChange(of: viewModel.preferences.lightBoldScale) {
                    viewModel.updateLightBoldScale()
                }
            Text("Light/Bold Scale: \(Int(viewModel.preferences.lightBoldScale))")
                
            Slider(value: $viewModel.preferences.fizzinessScale, in: 0...5, step: 1)
                .padding()
                .onChange(of: viewModel.preferences.fizzinessScale) {
                    viewModel.updateFizzinessScale()
                }
            Text("Fizziness Scale: \(Int(viewModel.preferences.fizzinessScale))")
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
