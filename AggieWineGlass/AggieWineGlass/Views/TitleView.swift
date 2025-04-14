//
//  TitleView.swift
//  AggieWineGlass
//
//  Created by Wild, Gabe on 4/9/25.
//

import SwiftUI

struct TitleView: View {
    @EnvironmentObject var preferences: UserPreferences
    @EnvironmentObject var wineDataInfo: WineDataInfo

    @State private var showCategorySelection = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color("PrimaryColor")
                    .ignoresSafeArea()

                VStack {
                    Spacer(minLength: 80)

                    VStack(spacing: 15) {
                        Image("TAMULogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)

                        Text("Aggie Wine Glass")
                            .font(.custom("Oswald-Regular", size: 36))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }

                    Spacer()

                    Button(action: {
                        withAnimation {
                            showCategorySelection = true
                        }
                    }) {
                        Text("Start")
                            .font(.custom("Oswald-Regular", size: 24))
                            .foregroundColor(Color("PrimaryColor"))
                            .padding()
                            .padding(.horizontal, 20)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 80)
                }
                .padding()
            }

            .navigationDestination(isPresented: $showCategorySelection) {
                CategorySelectionView(
                    preferences: preferences,
                    wineDataInfo: wineDataInfo
                )
            }
        }
    }
}
