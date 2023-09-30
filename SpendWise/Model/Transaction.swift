//
//  Transaction.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-28.
//

import Foundation

struct Transaction {
    
    var date: Date
    var currentBalance: Double?
    var amount: Double
    var isExpense: Bool
    var description: String
    var location: String
    var expenseCategory: String?
    
}

struct TransactionWrapper {
    
    var firstDate: Date
    var lastDate: Date
    var isWeekly: Bool
    var totalIncome: Double
    var totalExpense: Double
    var transactions: [Transaction]
    var expenseForCategory: [String:Double]
    
}
