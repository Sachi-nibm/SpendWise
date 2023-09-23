//
//  BudgetSetupViewModel.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-22.
//

import Foundation

class BudgetSetupViewModel: ObservableObject {
    
    @Published var balanceStr: String = "0.00"
    @Published var balance: Double?
    @Published var categories: [Category] = []
    
    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""
    
    func addInitialCategories() {
        categories = [
            Category(id: "save", isWeekly: false, label: "Saving", colourCode: "Green", budget: 0),
            Category(id: "food", isWeekly: false, label: "Food & Beverage", colourCode: "Mint", budget: 0),
            Category(id: "leisure", isWeekly: false, label: "Leisure", colourCode: "Orange", budget: 0),
            Category(id: "maintain", isWeekly: false, label: "Maintenance", colourCode: "Teal", budget: 0),
            Category(id: "daily", isWeekly: false, label: "Daily Expenses", colourCode: "Yellow", budget: 0),
            Category(id: "other", isWeekly: false, label: "Other", colourCode: "Indigo", budget: 0)
        ]
    }
    
    func saveBudget(_ balanceStr: String, completion: @escaping (_ isSuccess: Bool) -> Void) {
        let tmpBalance = Double(balanceStr) ?? 0
        if tmpBalance < 1000 {
            errorMessage = "Please enter a valid amount!"
            showAlert = true
            completion(false)
        } else {
            balance = Double(balanceStr)
            completion(true)
        }
        // Save to firestore
    }
    
    func saveData(_ budgetStrArray: [String], _ budgetPeriodArray: [String]) {
        var duplicateColor = false
        var collectedColors: [String] = []
        for category in categories {
            if (collectedColors.contains(category.colourCode)) {
                duplicateColor = true
                break
            } else {
                collectedColors.append(category.colourCode)
            }
        }
        if (duplicateColor) {
            errorMessage = "Duplicated colours found! As this might cause confusion in the dashboard please change."
            showAlert = true
        } else {
            for (index, budgetStr) in budgetStrArray.enumerated() {
                categories[index].budget = Double(budgetStr) ?? 0
            }
            for (index, budgetPeriod) in budgetPeriodArray.enumerated() {
                categories[index].isWeekly = (budgetPeriod == "week")
            }
            // Save to firestore
        }
    }
    
}
