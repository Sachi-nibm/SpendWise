//
//  TabAddTransactionViewModel.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-27.
//

import Foundation

class TabAddTransactionViewModel: ObservableObject {
    
    @Published var categories: [Category] = CategoryData.categories
    @Published var transactionType = "expense"
    @Published var categoryID = CategoryData.categories[0].id
    @Published var recordDate = Date()
    @Published var description = ""
    @Published var location = ""
    
    @Published var loadingData = false
    @Published var showSuccess: Bool = false
    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""
    
    func saveTransaction(_ amountStr: String, _ balance: Double?, completion: @escaping () -> Void) {
        showSuccess = false
        guard let balance else {
            errorMessage = "Unexpected error. Please restart the application and try again"
            showAlert = true
            return
        }
        // Check if strings are empty
        if (
            description.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            location.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            amountStr.trimmingCharacters(in: .whitespacesAndNewlines) == "0.0"
        ) {
            errorMessage = "Please fill all fields with valid values"
            showAlert = true
        } else {
            if let amount = Double(amountStr) {
                var transaction = Transaction(
                    date: recordDate,
                    currentBalance: balance,
                    amount: amount,
                    isExpense: (transactionType == "expense"),
                    description: description,
                    location: location
                )
                if transactionType == "expense" {
                    transaction.expenseCategory = categoryID
                }
                loadingData = true
                FireStoreUtil.saveTransaction(transaction) { error in
                    DispatchQueue.main.async {
                        self.loadingData = false
                        if let error = error {
                            self.errorMessage = "\(error)"
                            self.showAlert = true
                        } else {
                            // Reset data
                            self.showSuccess = true
                            self.errorMessage = "Data save successfully."
                            self.showAlert = true
                            self.categories = CategoryData.categories
                            self.categoryID = CategoryData.categories[0].id
                            self.recordDate = Date()
                            self.description = ""
                            self.location = ""
                            completion()
                        }
                    }
                }
            } else {
                errorMessage = "Please enter a valid amount"
                showAlert = true
            }
        }
    }
    
}
