//
//  ExampleViewModel.swift
//  AggieWineGlass
//
//  Created by Wild, Gabe on 4/2/25.
//

// ViewModel: handles data and logic for the View
// These classes are the brains of the models. They handle logic of data, data stroage, and will house the algorithms

import Foundation

class ExampleViewModel: ObservableObject {
    // Published makes SwiftUI update the view when this changes
    @Published var exampleList: [ExampleModel] = []

    init() {
        loadExamples()
    }

    // Function to do XYZ
    func loadExamples() {
        exampleList = [
            ExampleModel(name: "Item A", number: 1, optionalNum: nil, list: [1, 2]),
            ExampleModel(name: "Item B", number: 2, optionalNum: 42, list: [5, 6]),
            ExampleModel(name: "Item C", number: 3, optionalNum: nil, list: [10, 20, 30])
        ]
    }
}
