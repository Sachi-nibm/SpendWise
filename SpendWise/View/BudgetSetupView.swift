//
//  BudgetSetupView.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-21.
//

import SwiftUI
import Combine

struct BudgetSetupView: View {
    
    @ObservedObject var budgetViewModel = BudgetSetupViewModel()
    @State var currentTabIndex = 0
    
    init() {
        budgetViewModel.addInitialCategories()
    }
    
    var body: some View {
        TabView(selection: $currentTabIndex) {
            VStack {
                WelcomeTabView(tabIndex: $currentTabIndex)
            }.tag(0)
            VStack {
                SecondTabView(tabIndex: $currentTabIndex, budgetViewModel: budgetViewModel)
            }.tag(1)
            VStack {
                ThirdTabView(tabIndex: $currentTabIndex, categories: $budgetViewModel.categories, budgetViewModel: budgetViewModel)
            }.tag(2)
        }
        .animation(.easeInOut, value: currentTabIndex)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .onAppear {
            UIScrollView.appearance().isScrollEnabled = false
        }
        .navigationTitle("SET BUDGET")
        .alert(isPresented: $budgetViewModel.showAlert) {
            Alert(title: Text("ERROR"), message: Text(budgetViewModel.errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}

private struct WelcomeTabView: View {
    
    @Binding var tabIndex: Int
    
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            Image("spendWise_logo")
                .resizable()
                .scaledToFit()
                .padding(.all, 50)
                .background(.gray.opacity(0.10))
                .cornerRadius(.infinity)
                .padding(.horizontal, 70)
            Spacer()
            Text("WELCOME TO")
                .multilineTextAlignment(.center)
                .font(.subheadline)
            Text("Spend Wise")
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .padding(.vertical, 10)
            Text("Please follow these simple steps to setup this application.")
                .font(.subheadline)
                .frame(width: 250)
                .multilineTextAlignment(.center)
            Spacer()
            Text("Step 1 out of 3")
                .font(.caption)
                .frame(width: 300)
                .padding(.bottom, 15)
        }
        HStack {
            Button() {
                tabIndex = 1
            } label: {
                Text("START")
                    .padding(.leading)
                Label("", systemImage: "chevron.right")
            }
            .font(.title2)
            .frame(width: 140, height: 45)
            .background(Color.blue)
            .foregroundColor(Color.white)
            .cornerRadius(10)
        }
        Spacer()
    }
}

private struct SecondTabView: View {
    
    @Binding var tabIndex: Int
    @State var budgetViewModel: BudgetSetupViewModel
    
    @State var balanceStr = "0.00"
    
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            Text("Enter Starting Balance")
                .font(.subheadline)
                .padding(.horizontal, 50)
                .multilineTextAlignment(.center)
            HStack {
                Text("Rs")
                    .multilineTextAlignment(.leading)
                    .font(.title)
                TextField("0.00", text: $balanceStr)
                    .onReceive(Just(balanceStr)) { newValue in
                        var filtered = newValue.filter { "0123456789.".contains($0) }
                        print(filtered)
                        if filtered != newValue {
                            self.balanceStr = filtered
                        } else {
                            filtered = filtered.replacingOccurrences(of: ".", with: "")
                            let floatVal = Double(filtered)
                            if let floatVal {
                                self.balanceStr = String(format: "%.2f", (floatVal/100))
                            }
                        }
                    }
                    .keyboardType(.numberPad)
                    .autocorrectionDisabled()
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    .padding(.vertical, 10)
                    .multilineTextAlignment(.trailing)
            }
            .padding(.horizontal, 15)
            .overlay(RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray, lineWidth: 1)
            )
            .padding(.horizontal, 40)
            .padding(.vertical)
            Text("This amount is your starting balance. Your expenses will be deducted from this.")
                .font(.subheadline)
                .padding(.horizontal, 50)
                .multilineTextAlignment(.center)
            Spacer()
            Text("Step 2 out of 3")
                .font(.caption)
                .frame(width: 300)
                .padding(.bottom, 15)
        }
        HStack {
            Spacer()
            Button() {
                tabIndex -= 1
            } label: {
                Label("", systemImage: "chevron.left")
                Text("Back")
                    .padding(.trailing)
            }
            .font(.title2)
            .frame(width: 118, height: 43)
            .background(Color.gray.opacity(0.20))
            .foregroundColor(Color.blue)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 1)
            )
            Spacer()
            Button() {
                budgetViewModel.saveBudget(balanceStr) { isSuccess in
                    if isSuccess {
                        tabIndex += 1
                    }
                }
            } label: {
                Text("Next")
                    .padding(.leading)
                Label("", systemImage: "chevron.right")
            }
            .font(.title2)
            .frame(width: 120, height: 45)
            .background(Color.blue)
            .foregroundColor(Color.white)
            .cornerRadius(10)
            Spacer()
        }
        Spacer()
    }
}

private struct ThirdTabView: View {
    
    @EnvironmentObject var sessionData: SessionData
    
    @Binding var tabIndex: Int
    @Binding var categories: [Category]
    @State var budgetViewModel: BudgetSetupViewModel
    
    @State private var budgetStr = Array(repeating: "0.0", count: 6)
    @State private var budgetPeriod = Array(repeating: "month", count: 6)
    let colours = CategoryData.categoryColors
    
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
            Spacer()
            Text("Step 3 out of 3")
                .font(.caption)
                .frame(width: 300)
                .padding(.bottom, 15)
        }
        HStack {
            Spacer()
            Button() {
                tabIndex -= 1
            } label: {
                Label("", systemImage: "chevron.left")
                Text("Back")
                    .padding(.trailing)
            }
            .font(.title2)
            .frame(width: 118, height: 43)
            .background(Color.gray.opacity(0.20))
            .foregroundColor(Color.blue)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 1)
            )
            Spacer()
            Button() {
                budgetViewModel.saveData(false, budgetStr, budgetPeriod) { categories in
                    if let categories = categories {
                        sessionData.currentUser?.categories = categories
                    }
                }
            } label: {
                Text("Save")
                    .padding(.leading)
                Label("", systemImage: "checkmark.circle.fill")
            }
            .font(.title2)
            .frame(width: 120, height: 45)
            .background(Color.blue)
            .foregroundColor(Color.white)
            .cornerRadius(10)
            Spacer()
        }
        Spacer()
    }
}

struct BudgetSetupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BudgetSetupView()
        }
    }
}
