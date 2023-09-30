//
//  UpdateBudgetView.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-30.
//

import SwiftUI
import Combine

struct UpdateBudgetView: View {
    
    @EnvironmentObject var sessionData: SessionData
    
    @State var categories: [Category]
    @State var budgetViewModel: BudgetSetupViewModel
    
    @State private var isLoading = false
    @State private var showSuccess = false
    @State private var budgetStr: [String]
    @State private var budgetPeriod = Array(repeating: "week", count: 6)
    let colours = CategoryData.categoryColors
    
    // Load user saved data which will be updated
    init(_ sessionDataIn: SessionData) {
        let localBudget = BudgetSetupViewModel()
        localBudget.addInitialCategories()
        if let currentUser = sessionDataIn.currentUser {
            print("currentUser")
            print(currentUser)
            localBudget.balance = currentUser.balance
            localBudget.balanceStr = String(format: "%.2f", currentUser.balance)
            for userCat in currentUser.categories {
                for index in 0..<localBudget.categories.count {
                    if (userCat.id == localBudget.categories[index].id) {
                        localBudget.categories[index].colourCode = userCat.colourCode
                        if sessionDataIn.isWeekly {
                            localBudget.categories[index].budget = userCat.budget
                        } else {
                            localBudget.categories[index].budget = (userCat.budget/4)
                        }
                        break
                    }
                }
            }
            var localBudgetStr = Array(repeating: "0.0", count: 6)
            for index in 0..<localBudget.categories.count {
                localBudgetStr[index] = String(format: "%.1f", localBudget.categories[index].budget)
            }
            categories = localBudget.categories
            budgetViewModel = localBudget
            budgetStr = localBudgetStr
        } else {
            categories = localBudget.categories
            budgetViewModel = localBudget
            budgetStr = []
        }
        
    }
    
    var body: some View {
        VStack() {
            Spacer()
            List {
                ForEach(categories.indices, id: \.self) { index in
                    VStack {
                        HStack {
                            Picker(categories[index].label, selection: $categories[index].colourCode) {
                                ForEach(Array(colours.keys), id: \.self) { key in
                                    Text(key)
                                        .tag(key)
                                }
                            }
                            .pickerStyle(.menu)
                            Rectangle()
                                .fill(colours[categories[index].colourCode] ?? .clear)
                                .frame(width: 20, height: 20)
                                .cornerRadius(5)
                        }
                        HStack {
                            Picker("", selection: $budgetPeriod[index]) {
                                Text("Monthly Budget")
                                    .tag("month")
                                Text("Weekly Budget")
                                    .tag("week")
                            }
                            .labelsHidden()
                            .pickerStyle(.menu)
                            .padding(.leading, -10)
                            Spacer()
                            HStack {
                                Text("Rs")
                                    .multilineTextAlignment(.leading)
                                    .font(.title3)
                                TextField("0.0", text: $budgetStr[index])
                                    .onReceive(Just(budgetStr[index])) { newValue in
                                        var filtered = newValue.filter { "0123456789.".contains($0) }
                                        print(filtered)
                                        if filtered != newValue {
                                            self.budgetStr[index] = filtered
                                        } else {
                                            filtered = filtered.replacingOccurrences(of: ".", with: "")
                                            let floatVal = Double(filtered)
                                            if let floatVal {
                                                self.budgetStr[index] = String(format: "%.1f", (floatVal/10))
                                            }
                                        }
                                    }
                                    .keyboardType(.numberPad)
                                    .autocorrectionDisabled()
                                    .multilineTextAlignment(.trailing)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .fontDesign(.rounded)
                                    .padding(.vertical, 10)
                                    .multilineTextAlignment(.trailing)
                            }
                            .padding(.leading)
                        }
                    }
                    .listStyle(.plain)
                }
            }
        }
        .animation(.easeIn, value: isLoading)
        .disabled(isLoading)
        
        HStack {
            Spacer()
            Button() {
                isLoading = true
                budgetViewModel.categories = categories
                budgetViewModel.saveData(true, budgetStr, budgetPeriod) { categories in
                    DispatchQueue.main.async {
                        self.isLoading = false
                        if let categories = categories {
                            showSuccess = true
                            sessionData.currentUser?.categories = categories
                        }
                    }
                }
            } label: {
                if (isLoading) {
                    ProgressView()
                        .tint(.primary)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .font(.title3)
                } else {
                    Text("Save Data ")
                    Label("", systemImage: "square.and.arrow.down")
                }
            }
            .font(.title2)
            .padding(.vertical, 5)
            .padding(.horizontal, 20)
            .background(Color.blue)
            .foregroundColor(Color.white)
            .cornerRadius(10)
            Spacer()
        }
        .alert(isPresented: $showSuccess) {
            Alert(
                title: Text("SUCCESS"),
                message: Text("Data saved successfully."),
                dismissButton: .default(Text("OK")))
        }
        .animation(.easeIn, value: isLoading)
        .disabled(isLoading)
        Spacer()
    }
}
