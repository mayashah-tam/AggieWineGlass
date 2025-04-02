//
//  ExampleModel.swift
//  AggieWineGlass
//
//  Created by Wild, Gabe on 4/2/25.
//

//  The purpose of the models folder is to create files for the objects and data structures you will use

import Foundation

struct ExampleModel: Identifiable, Equatable {
    // Identifiable: required for SwiftUI lists and ForEach — helps uniquely identify each item
    // Equatable: lets you compare two models using == (e.g., for filtering, testing, etc.)

    var id = UUID() // Auto-generate a unique ID
                    // 'id' is required by Identifiable — must uniquely identify each instance
                    // SwiftUI uses this under the hood for rendering lists efficiently
    
    var name: String
    var number: Int
    
    var optionalNum: Int? // ? is the Optional Type (Allows Null)
    
    var list: [Int] //  Declaring an Array of type X is [X] (i.e. [Int] is an array of integers
}
