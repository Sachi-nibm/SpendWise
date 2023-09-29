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
    
//    init() {
//        firstDate = Date()
//        lastDate = Date()
//        isWeekly = false
//        totalIncome = 0
//        totalExpense = 0
//        transactions = []
//    }
//
//    init(firstDate: Date, lastDate: Date, isWeekly: Bool, totalIncome: Double, totalExpense: Double, transactions: [Transaction]) {
//        self.firstDate = firstDate
//        self.lastDate = lastDate
//        self.isWeekly = isWeekly
//        self.totalIncome = totalIncome
//        self.totalExpense = totalExpense
//        self.transactions = transactions
//    }
    
}
