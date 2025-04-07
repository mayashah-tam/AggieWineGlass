//
//  WineView.swift
//  AggieWineGlass
//
//  Created by Maya Shah on 4/6/25.
//

import UIKit

class WineViewController: UIViewController {
    var viewModel = WineViewModel()
    
    let filePath = "/path/to/WineListData.csv"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.loadWineData(filepath: filePath)
        
        if !viewModel.wines.isEmpty {
            for wine in viewModel.wines {
                print(wine)
            }
        } else {
            print("No wines available")
        }
    }
}
