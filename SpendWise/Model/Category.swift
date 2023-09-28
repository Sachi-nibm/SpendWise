//
//  CategoryModel.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-22.
//

import SwiftUI

struct Category: Identifiable, Hashable {
    
    // Cat code
    var id: String
    var label: String
    var colourCode: String
    var budget: Double
    
}

struct CategoryData {
    
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
        "Purple": .purple
    ]
    
    static let categories = [
        Category(id: "save", label: "Saving", colourCode: "Green", budget: 0),
        Category(id: "food", label: "Food & Beverage", colourCode: "Mint", budget: 0),
        Category(id: "leisure", label: "Leisure", colourCode: "Orange", budget: 0),
        Category(id: "maintain", label: "Maintenance", colourCode: "Teal", budget: 0),
        Category(id: "daily", label: "Daily Expenses", colourCode: "Yellow", budget: 0),
        Category(id: "other", label: "Other", colourCode: "Indigo", budget: 0)
    ]
    
}
