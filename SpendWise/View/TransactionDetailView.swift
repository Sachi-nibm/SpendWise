//
//  TransactionDetailView.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-29.
//

import SwiftUI

struct TransactionDetailView: View {
    
    @State var transaction: Transaction
    
    var body: some View {
        List {
            if transaction.isExpense {
                Section(header: Text("CATEGORY")) {
                    HStack {
                        Text("Category")
                            .bold()
                        Text(CategoryData.categoryLabels[transaction.expenseCategory ?? "X"] ?? "N/A")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
            }
            
            Section(header: Text("DETAILS")) {
                VStack {
                    DatePicker(selection: $transaction.date, in: ...Date.now, displayedComponents: .date) {
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
                        Text(String(format: "%.2f", transaction.amount))
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
                    TextField("Enter Description", text: $transaction.description, axis: .vertical)
                        .lineLimit(2...)
                        .textFieldStyle(.roundedBorder)
                }
                VStack {
                    Text("Location")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("Enter Location", text: $transaction.location)
                        .textFieldStyle(.roundedBorder)
                }
            }
            .listStyle(.plain)
            .disabled(true)
        }
        .navigationBarTitle((transaction.isExpense ? "Expense" : "Income"), displayMode: .large)
    }
}
