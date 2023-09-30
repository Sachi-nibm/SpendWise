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
    
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""
    
    func addInitialCategories() {
        categories = CategoryData.categories
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
    }
    
    func saveData(_ isUpdate: Bool, _ budgetStrArray: [String], _ budgetPeriodArray: [String], completion: @escaping ([Category]?) -> Void) {
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
            for index in 0..<categories.count {
                let weekly = (budgetPeriodArray[index] == "week")
                if (weekly) {
                    categories[index].budget = Double(budgetStrArray[index]) ?? 0
                } else {
                    if let value = Double(budgetStrArray[index]) {
                        categories[index].budget = (value/4)
                    } else {
                        categories[index].budget = 0
                    }
                }
            }
            isLoading = true
            FireStoreUtil.saveBudget(isUpdate, (balance ?? 0), categories) { error in
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let error = error {
                        self.errorMessage = "\(error)"
                        self.showAlert = true
                    } else {
                        completion(self.categories)
                    }
                }
            }
        }
    }
    
    static func getSetupViewModel(_ sessionData: SessionData) -> BudgetSetupViewModel {
        let budgetViewModel = BudgetSetupViewModel()
        budgetViewModel.categories = sessionData.currentUser?.categories ?? []
        budgetViewModel.balance = (sessionData.currentUser?.balance ?? 0)
        budgetViewModel.balanceStr = String(format: "%.2f", (sessionData.currentUser?.balance ?? 0))
        return budgetViewModel
    }
}
