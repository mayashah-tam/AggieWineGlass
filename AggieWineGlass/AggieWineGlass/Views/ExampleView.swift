//
//  ContentView.swift
//  AggieWineGlass
//
//  Created by Wild, Gabe on 4/2/25.
//

// This is a SwiftUI View — it describes what should appear on screen (the UI)
// All views must conform to the `View` protocol and define a `body`
// The body contains UI components laid out in a hierarchy

import SwiftUI

struct ExampleView: View {
    // Connect the ViewModel to the view
    @StateObject private var viewModel = ExampleViewModel()
    
    var body: some View {
        NavigationView { // Stack for navigating between views
            List {
                // Loop through the data
                ForEach(viewModel.exampleList) { item in
                    VStack(alignment: .leading) { // Vertical Stack for alignment
                        Text(item.name)
                            .font(.headline)
                        Text("Number: \(item.number)")
                        if let optional = item.optionalNum {
                            Text("Optional: \(optional)")
                        } else {
                            Text("Optional: nil")
                        }
                        Text("List: \(item.list.map { String($0) }.joined(separator: ", "))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Example List")
        }
    }
}

// To view your component in the side view editor, create one of these components below
// Name it <Name>_Previews, and then call the view in the static function
// This shows you what the view will look like (useful for quick UI changes)
struct ExampleView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleView()
    }
}
