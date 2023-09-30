//
//  TabAddTransactionView.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-27.
//

import SwiftUI
import Combine

struct TabAddTransactionView: View {
    
    @EnvironmentObject var sessionData: SessionData
    @ObservedObject var tabAddViewModel = TabAddTransactionViewModel()
    
    @State var amountStr = "0.00"
    
    var body: some View {
        VStack {
            VStack {
                Text("AVAILABLE FUNDS")
                HStack {
                    Text("Rs")
                        .multilineTextAlignment(.leading)
                        .font(.title)
                    Text(String(format: "%.2f", sessionData.currentUser?.balance ?? 0))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                        .padding(.vertical, 10)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 15)
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 1)
                )
                .padding(.horizontal, 30)
                .padding(.top, -5)
            }
            .padding(.top, 5)
            
            List {
                Section(header: Text("TYPE")) {
                    HStack {
                        Text("Transaction Type")
                            .bold()
                        Picker("", selection: $tabAddViewModel.transactionType) {
                            Text("Expense")
                                .tag("expense")
                            Text("Income")
                                .tag("income")
                        }
                        .labelsHidden()
                        .pickerStyle(.menu)
                        .padding(.leading, -10)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                
                // show category only for expenses
                if tabAddViewModel.transactionType == "expense" {
                    Section(header: Text("CATEGORY")) {
                        HStack {
                            Text("Category")
                                .bold()
                            Picker("", selection: $tabAddViewModel.categoryID) {
                                ForEach(tabAddViewModel.categories, id: \.id) { index in
                                    Text(index.label)
                                        .tag(index.id)
                                }
                            }
                            .labelsHidden()
                            .pickerStyle(.menu)
                            .padding(.leading, -10)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                }
                
                Section(
                    header: Text("DETAILS"),
                    footer:
                        HStack(alignment: .center) {
                            if tabAddViewModel.transactionType == "expense" {
                                Button {
                                    tabAddViewModel.saveTransaction(amountStr, sessionData.currentUser?.balance) {
                                        amountStr = "0.00"
                                        tabAddViewModel.loadingData = true
                                        sessionData.reloadUserData() { error in
                                            if let _ = error {
                                                print("Error in data reload!")
                                            }
                                            tabAddViewModel.loadingData = false
                                        }
                                    }
                                } label: {
                                    if (tabAddViewModel.loadingData) {
                                        ProgressView()
                                            .tint(.white)
                                            .padding(.horizontal, 50)
                                            .padding(.vertical, 10)
                                            .font(.title3)
                                    } else {
                                        Text("Save Expense")
                                            .padding(.horizontal)
                                            .padding(.vertical, 10)
                                            .font(.title3)
                                    }
                                }
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(.infinity)
                            } else {
                                Button {
                                    tabAddViewModel.saveTransaction(amountStr, sessionData.currentUser?.balance) {
                                        amountStr = "0.00"
                                        sessionData.reloadUserData() { error in
                                            tabAddViewModel.loadingData = false
                                            if let _ = error {
                                                print("Error in data reload!")
                                                tabAddViewModel.errorMessage = "Data saved. Yet unable to reload data."
                                                tabAddViewModel.showAlert = true
                                            } else {
                                                tabAddViewModel.showSuccess = true
                                                tabAddViewModel.errorMessage = "Data saved successfully"
                                                tabAddViewModel.showAlert = true
                                            }
                                        }
                                    }
                                } label: {
                                    // disable view and show spinner when saving
                                    if (tabAddViewModel.loadingData) {
                                        ProgressView()
                                            .tint(.primary)
                                            .padding(.horizontal, 50)
                                            .padding(.vertical, 10)
                                            .font(.title3)
                                    } else {
                                        Text("Save Income")
                                            .padding(.horizontal)
                                            .padding(.vertical, 10)
                                            .font(.title3)
                                    }
                                }
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(.infinity)
                            }
                        }
                        .frame(maxWidth: .infinity ,alignment: .center)
                        .padding(.vertical, 20)
                ) {
                    VStack {
                        DatePicker(selection: $tabAddViewModel.recordDate, in: ...Date.now, displayedComponents: .date) {
                            Text("Date")
                        }
                        .datePickerStyle(.compact)
                        .padding(.vertical, 2)
                    }
                    HStack {
                        Text("Amount")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bold()
                        Spacer()
                        HStack {
                            Text("Rs")
                                .multilineTextAlignment(.leading)
                                .font(.title3)
                            TextField("0.0", text: $amountStr)
                                .onReceive(Just(amountStr)) { newValue in
                                    var filtered = newValue.filter { "0123456789.".contains($0) }
                                    print(filtered)
                                    if filtered != newValue {
                                        self.amountStr = filtered
                                    } else {
                                        filtered = filtered.replacingOccurrences(of: ".", with: "")
                                        let floatVal = Double(filtered)
                                        if let floatVal {
                                            self.amountStr = String(format: "%.1f", (floatVal/10))
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
                                .padding(.trailing, 2)
                                .multilineTextAlignment(.trailing)
                        }
                        .padding(.leading)
                    }
                    VStack {
                        Text("Description")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("Enter Description", text: $tabAddViewModel.description, axis: .vertical)
                            .lineLimit(2...)
                            .textFieldStyle(.roundedBorder)
                    }
                    VStack {
                        Text("Location")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("Enter Location", text: $tabAddViewModel.location)
                            .textFieldStyle(.roundedBorder)
                    }
                }
                .listStyle(.plain)
            }
        }
        .animation(.easeIn, value: tabAddViewModel.loadingData)
        .disabled(tabAddViewModel.loadingData)
        .alert(isPresented: $tabAddViewModel.showAlert) {
            Alert(
                title: Text(tabAddViewModel.showSuccess ? "SUCCESS" : "ERROR"),
                message: Text(tabAddViewModel.errorMessage),
                dismissButton: .default(Text("OK")))
        }
    }
}

struct TabAddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TabAddTransactionView()
    }
}
