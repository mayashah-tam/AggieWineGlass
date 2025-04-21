//
//  PersonalizataionSelectionView.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/9/25.
//

import SwiftUI

struct PersonalizationSelectionView: View {
    @Binding var path: NavigationPath
    @EnvironmentObject var preferences: UserPreferences
    @EnvironmentObject var wineDataInfo: WineDataInfo

    @StateObject private var viewModel: PersonalizationSelectionViewModel
    @State private var selection: String = "Less"

    init(path: Binding<NavigationPath>, preferences: UserPreferences) {
        self._path = path
        self._viewModel = StateObject(wrappedValue:
            PersonalizationSelectionViewModel(
                preferences: preferences
            )
        )
    }

    var body: some View {
        ZStack {
            Color("PrimaryColor").ignoresSafeArea()

            VStack(spacing: 20) {
                SectionTitleView(text: "Personalization Level")

                Spacer()

                HStack(spacing: 0) {
                    ForEach(["More", "Less"], id: \.self) { option in
                        Button(action: {
                            selection = option
                            if option == "More" {
                                viewModel.turnOnMorePersonalization()
                            } else {
                                viewModel.turnOffMorePersonalization()
                            }
                        }) {
                            Text(option)
                                .font(.custom("Oswald-Regular", size: 16))
                                .foregroundColor(
                                    selection == option
                                        ? Color("PrimaryColor")
                                        : .white
                                )
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .background(
                                    selection == option
                                        ? Color.white
                                        : Color.clear
                                )
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white, lineWidth: 2)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                .frame(height: UIScreen.main.bounds.height * 0.56)

                Spacer()

                Button(action: {
                    withAnimation {
                        path.append(Route.swipe)
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
            .padding()
        }
    }
}
