//
//  PersonalizataionSelectionView.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/9/25.
//

import SwiftUI

struct PersonalizataionSelectionView: View {
    @StateObject var viewModel = PersonalizationSelectionViewModel()

    var body: some View {
        VStack {
            Text("Do you want more or less personalization?")
                .font(.headline)
                .padding()
            
            HStack {
                Button(action: {
                    viewModel.turnOnMorePersonalization()
                }) {
                    Text("More")
                        .foregroundColor(.blue)
                        .padding()
                }
                
                Button(action: {
                    viewModel.turnOffMorePersonalization()
                }) {
                    Text("Less")
                        .foregroundColor(.red)
                        .padding()
                }
            }
        }
        .padding()
    }
}

