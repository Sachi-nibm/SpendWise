//
//  CategoryModel.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-22.
//

import SwiftUI

struct Category: Identifiable {
    
    // Cat code
    var id: String
    var isWeekly: Bool
    var label: String
    var colourCode: String
    var budget: Double
    
}

struct CategoryColors {
    
    static let categoryColors: [String: Color] = [
        "Blue": .blue,
        "Gray": .gray,
        "Mint": .mint,
        "Indigo": .indigo,
        "Teal": .teal,
        "Orange": .orange,
        "Green": .green,
        "Yellow": .yellow,
        "Cyan": .cyan,
        "Brown": .brown,
        "Pink": .pink,
        "Purple": .purple,
        "Red": .red
    ]
    
}
