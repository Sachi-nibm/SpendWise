//
//  User.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-15.
//

import Foundation

struct User: Identifiable {
    
    // Email
    var id: String
    var categories: [Category]
    var balance: Double
    
}
