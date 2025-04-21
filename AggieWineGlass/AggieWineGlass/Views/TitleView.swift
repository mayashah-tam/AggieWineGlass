//
//  TitleView.swift
//  AggieWineGlass
//
//  Created by Wild, Gabe on 4/9/25.
//

import SwiftUI

struct TitleView: View {
    @Binding var path: NavigationPath
    @EnvironmentObject var preferences: UserPreferences
    @EnvironmentObject var wineDataInfo: WineDataInfo

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
                            path.append(Route.categorySelection)
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
        }
    }
}

struct SectionTitleView: View {
    var text: String

    var body: some View {
        Text(text)
            .font(.custom("Oswald-Regular", size: 34))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 32)
            .padding(.horizontal)
    }
}
