//
//  RootView.swift
//  AggieWineGlass
//
//  Created by Wild, Gabe on 4/9/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var preferences: UserPreferences
    @EnvironmentObject var wineDataInfo: WineDataInfo
    
    var body: some View {
        NavigationStack {
            TitleView()
        }
    }
}
