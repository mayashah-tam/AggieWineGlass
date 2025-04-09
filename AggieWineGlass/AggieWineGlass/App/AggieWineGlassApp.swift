//
//  AggieWineGlassApp.swift
//  AggieWineGlass
//
//  Created by Wild, Gabe on 4/2/25.
//

//
//  This is the main entry point into the app. All components will be called from here, and this will be the universal home for the App
//  See Example Files for Quick Tutorials and explanations to get up to speed on project structure
//
//  In order to run the App in the official simulator and view an execution as it plays out in the app, hit the play button on the left side bar (it builds, then runs [patience])
//  Make sure the Sim is set to an iPhone (At the top AggieWineGlass > IPhone, not mac)
//
//  The Preview Content is there so we can see the previews
//  The Assests file is how we define colors, pictures, logos etc. to be used in the app



import SwiftUI

@main
struct AggieWineGlassApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                VStack {
                    NavigationLink(destination: WineView()) {
                        Text("Go to Wine View")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                    }
                    
                    NavigationLink(destination: SliderScalesView()) {
                        Text("Go to Slider Scales View")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                    }
                    
                    NavigationLink(destination: CategorySelectionView()) {
                        Text("Go to Category Selection View")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                    }
                    
                    NavigationLink(destination: FlavorProfileSelectionView()) {
                        Text("Go to Flavor Profile Selection View")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                    }
                    
                    NavigationLink(destination: PairingsSelectionView()) {
                        Text("Go to Pairings Selection View")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                    }
                    
                    NavigationLink(destination: RegionsSelectionView()) {
                        Text("Go to Regions Selection View")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                    }
                }
                .navigationTitle("Main Menu")
            }
        }
    }
}




