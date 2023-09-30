//
//  TabTransactionHistoryView.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-28.
//

import SwiftUI

struct TabTransactionHistoryView: View {
    
    @EnvironmentObject var sessionData: SessionData
    
    @State var startDate = Date()
    @State var endDate = Date()
    
    @State var totIncome: Double = 0
    @State var totExpense: Double = 0
    
    @State var transactions: [Transaction] = []
    
    init() {
        transactions = FireStoreUtil.getTransactionsForDuration(startDate, endDate)?.transactions ?? []
        calculateTotal()
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack(spacing: 5) {
                    Text("FROM")
                    // Data is filtered on change of dates
                    DatePicker(selection: $startDate, in: ...Date.now, displayedComponents: .date) {
                        Text("Date")
                    }
                    .datePickerStyle(.compact)
                    .padding(.vertical, 2)
                    .labelsHidden()
                    .onChange(of: startDate, perform: { value in
                        transactions = FireStoreUtil.getTransactionsForDuration(startDate, endDate)?.transactions ?? []
                        calculateTotal()
                    });
                }
                Spacer()
                VStack(spacing: 5) {
                    Text("TO")
                    DatePicker(selection: $endDate, in: ...Date.now, displayedComponents: .date) {
                        Text("Date")
                    }
                    .datePickerStyle(.compact)
                    .padding(.vertical, 2)
                    .labelsHidden()
                    .onChange(of: endDate, perform: { value in
                        transactions = FireStoreUtil.getTransactionsForDuration(startDate, endDate)?.transactions ?? []
                        calculateTotal()
                    });
                }
                Spacer()
            }
            
            HStack {
                Spacer()
                Text("Income: ")
                Text(String(format: "%.2f", totIncome))
                    .bold()
                    .foregroundColor(.green)
                Spacer()
                Text("|")
                    .bold()
                Spacer()
                Text("Expense: ")
                Text(String(format: "%.2f", totExpense))
                    .bold()
                    .foregroundColor(.red)
                Spacer()
            }
            .padding(.top, 5)
            .padding(.bottom, 5)
            
            List {
                if transactions.isEmpty {
                    Section(
                        header:
                            HStack (spacing: 0) {
                                Text("NO DATA FOUND")
                                    .foregroundColor(.black)
                                    .font(.title3)
                                    .bold()
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                    ) {}
                }
                Section() {
                    // Dynamically generate transactions
                    ForEach(transactions.indices, id: \.self) { index in
                        NavigationLink(destination: TransactionDetailView(transaction: transactions[index])) {
                            // Switch between expenses and incomes
                            if (transactions[index].isExpense) {
                                HStack(spacing: 0) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .padding(.vertical, 10)
                                        .frame(width: 8, alignment: .top)
                                        .foregroundColor(sessionData.getColorForCategoryCode(transactions[index].expenseCategory ?? "X"))
                                        .padding(.trailing, 5)
                                    Image(systemName: "tray.and.arrow.up.fill")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .padding(.all, 4)
                                        .cornerRadius(0.5)
                                        .foregroundColor(Color.red)
                                        .overlay(RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.red, lineWidth: 2)
                                        )
                                        .background(Color.red.opacity(0.1))
                                        .padding(5)
                                    Spacer()
                                    VStack {
                                        Text(formatDateToString(transactions[index].date))
                                            .font(.caption)
                                        Text(CategoryData.categoryLabels[transactions[index].expenseCategory ?? "X"] ?? "EXPENSE")
                                    }
                                    Spacer()
                                    Text(String(format: "%.2f", transactions[index].amount))
                                        .padding(.horizontal, 5)
                                        .bold()
                                }
                                .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
                                    return 0
                                }
                            } else {
                                HStack(spacing: 0) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .padding(.vertical, 10)
                                        .frame(width: 8, alignment: .top)
                                        .foregroundColor(.primary)
                                        .padding(.trailing, 5)
                                    Image(systemName: "tray.and.arrow.down.fill")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .padding(.all, 4)
                                        .cornerRadius(0.5)
                                        .foregroundColor(Color.green)
                                        .overlay(RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.green, lineWidth: 2)
                                        )
                                        .background(Color.green.opacity(0.1))
                                        .padding(5)
                                    Spacer()
                                    VStack {
                                        Text(formatDateToString(transactions[index].date))
                                            .font(.caption)
                                        Text("INCOME")
                                    }
                                    Spacer()
                                    Text(String(format: "%.2f", transactions[index].amount))
                                        .padding(.horizontal, 5)
                                        .bold()
                                }
                                .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
                                    return 0
                                }
                            }
                        }
                    }
                }
            }
        }
        // Reload data on view appear
        .onAppear() {
            transactions = FireStoreUtil.getTransactionsForDuration(startDate, endDate)?.transactions ?? []
            calculateTotal()
        }
    }
    
    // Helper functions
    func formatDateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    func calculateTotal() {
        totExpense = 0
        totIncome = 0
        for transaction in transactions {
            if (transaction.isExpense) {
                totExpense += transaction.amount
            } else {
                totIncome += transaction.amount
            }
        }
    }
}

struct TabTransactionHistory_Previews: PreviewProvider {
    static var previews: some View {
        TabTransactionHistoryView()
    }
}
