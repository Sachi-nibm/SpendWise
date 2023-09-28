//
//  FireStoreUtil.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-20.
//

import Foundation
import FirebaseDatabase
import SwiftUI

class FireStoreUtil {
    
    private static var email: String?
    static var ref: DatabaseReference?
    static var firebaseSnapshot: DataSnapshot?
    
    static func assignEmail(email: String) {
        FireStoreUtil.ref = Database.database(url: "https://spendwise-e47cf-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
        let modEmail = email.replacingOccurrences(of: "[@.#$\\[\\]]", with: "-", options: .regularExpression, range: nil)
        FireStoreUtil.email = modEmail
        print(modEmail)
    }
    
    static func removeEmail() {
        FireStoreUtil.ref = nil
        FireStoreUtil.email = nil
    }
    
    private static func loadDataFromFirebase(completion: @escaping (DataSnapshot?, Error?) -> Void) {
        guard let email = email, let ref = ref else {
            completion(nil, SpendWiseError.runtimeError("FireStoreUtil is not initialised!"))
            return
        }
        ref.child(email).getData(completion:  { error, snapshot in
            completion(snapshot, error)
        });
    }
    
    static func loadDataObjects(_ userEmail: String, completion: @escaping (User?, TransactionWrapper?, Error?) -> Void) {
        loadDataFromFirebase(completion:  { snapshot, error in
            if let error = error {
                completion(nil, nil, error)
            } else {
                if let snapshot = snapshot {
                    firebaseSnapshot = snapshot
                    let transactions = FireStoreUtil.getTransactionsForHome()
                    let balance: Double = (((snapshot.value as? NSDictionary)?["balance"] as? Double) ?? 0)
                    var categories: [Category] = []
                    for cat in CategoryData.categories {
                        var category = cat
                        let categoryData = snapshot.childSnapshot(forPath: cat.id).value as? NSDictionary
                        let catBudget: Double? = categoryData?["budget"] as? Double
                        let catColor: String? = categoryData?["colorCode"] as? String
                        if let catBudget = catBudget, let catColor = catColor {
                            category.colourCode = catColor
                            category.budget = catBudget
                            categories.append(category)
                        }
                    }
                    let user = User(id: userEmail, categories: categories, balance: balance)
                    completion(user, transactions, nil)
                } else {
                    completion(nil, nil, SpendWiseError.runtimeError("Database is not set!"))
                }
            }
        })
    }
    
    static func saveBudget(_ balance: Double, _ categories: [Category], completion: @escaping (Error?) -> Void) {
        if let ref = ref, let email = email {
            var data: [String:Any] = [
                "/balance": balance
            ]
            for category in categories {
                data["/\(category.id)/budget"] = category.budget
                data["/\(category.id)/colorCode"] = category.colourCode
            }
            ref.child(email).updateChildValues(data) { (error, _) in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        } else {
            completion(SpendWiseError.runtimeError("Database or Email is not set!"))
        }
    }
    
    static func saveTransaction(_ transaction: Transaction, completion: @escaping (Error?) -> Void) {
        if let ref = ref, let email = email {
            let balance: Double;
            if transaction.isExpense {
                balance = (transaction.currentBalance! - transaction.amount)
            } else {
                balance = (transaction.currentBalance! + transaction.amount)
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone.current
            let dateString = dateFormatter.string(from: transaction.date)
            
            guard let key = ref.child(email + "/transactions/" + dateString).childByAutoId().key else { return }
            
            ref.child(email).updateChildValues([
                "/balance": balance,
                "/transactions/\(dateString)/\(key)/amount": transaction.amount,
                "/transactions/\(dateString)/\(key)/isExpense": transaction.isExpense,
                "/transactions/\(dateString)/\(key)/date": dateString,
                "/transactions/\(dateString)/\(key)/description": transaction.description,
                "/transactions/\(dateString)/\(key)/location": transaction.location,
                "/transactions/\(dateString)/\(key)/category": transaction.expenseCategory as Any
            ]) { (error, _) in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        } else {
            completion(SpendWiseError.runtimeError("Database or Email is not set!"))
        }
    }
    
    static func getTransactionsForHome() -> TransactionWrapper? {
        let isWeekly = UserDefaults.standard.bool(forKey: "isWeekly")
        let timeDifference = TimeZone.current.secondsFromGMT()
        var startDate: Date
        var endDate: Date
        if isWeekly {
            var calendar = Calendar.current
            calendar.firstWeekday = 2
            let startComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
            startDate = calendar.date(from: startComponents)!
            startDate = calendar.date(byAdding: .second, value: timeDifference, to: startDate)!
            
            var components = DateComponents()
            components.weekOfYear = 1
            components.day = -1
            
            let endComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
            endDate = calendar.date(from: endComponents)!
            endDate = calendar.date(byAdding: components, to: endDate)!
            endDate = calendar.date(byAdding: .second, value: timeDifference, to: endDate)!
        } else {
            var calendar = Calendar.current
            calendar.firstWeekday = 2
            let startComponents = calendar.dateComponents([.year, .month], from: Date())
            startDate = calendar.date(from: startComponents)!
            startDate = calendar.date(byAdding: .second, value: timeDifference, to: startDate)!
            
            var components = DateComponents()
            components.month = 1
            components.day = -1
            
            let endComponents = calendar.dateComponents([.year, .month], from: Date())
            endDate = calendar.date(from: endComponents)!
            endDate = calendar.date(byAdding: components, to: endDate)!
            endDate = calendar.date(byAdding: .second, value: timeDifference, to: endDate)!
        }
        return getTransactionsForDuration(startDate, endDate)
    }
    
    static func getTransactionsForDuration(_ startDate: Date, _ endDate: Date) -> TransactionWrapper? {
        if let firebaseSnapshot = firebaseSnapshot {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone.current
            
            let timeDifference = TimeZone.current.secondsFromGMT()
            var calendar = Calendar.current
            calendar.firstWeekday = 2
            
            let startDateGMT = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: startDate))!
            var startDateLocal = calendar.date(byAdding: .second, value: timeDifference, to: startDateGMT)!
            
            let endDateGMT = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: endDate))!
            let endDateLocal = calendar.date(byAdding: .second, value: timeDifference, to: endDateGMT)!
            
            var totExpense = 0.0
            var totIncome = 0.0
            var categoryExpense: [String:Double] = [:]
            var transactions: [Transaction] = []
            
            while (true) {
                
                for child in firebaseSnapshot.childSnapshot(forPath: "/transactions/" + dateFormatter.string(from: startDateLocal)).children {
                    if let child = child as? DataSnapshot {
                        let transactionDic = child.value as? NSDictionary ?? [:]
                        let transaction = Transaction(
                            date: startDateLocal,
                            amount: (transactionDic["amount"] as? Double) ?? 0,
                            isExpense: (transactionDic["isExpense"] as? Bool)!,
                            description: (transactionDic["description"] as? String) ?? "",
                            location: (transactionDic["location"] as? String) ?? "",
                            expenseCategory: transactionDic["category"] as? String
                        )
                        if (transaction.isExpense) {
                            totExpense += transaction.amount
                            if let catExpense = categoryExpense[transaction.expenseCategory!] {
                                categoryExpense[transaction.expenseCategory!] = (catExpense + transaction.amount)
                            } else {
                                categoryExpense[transaction.expenseCategory!] = transaction.amount
                            }
                        } else {
                            totIncome += transaction.amount
                        }
                        transactions.append(transaction)
                    }
                }
                
                if (startDateLocal == endDateLocal) {
                    break
                } else {
                    startDateLocal = calendar.date(byAdding: .day, value: 1, to: startDateLocal)!
                }
            }
            let transactionWrapper = TransactionWrapper(
                firstDate: startDate,
                lastDate: endDate,
                isWeekly: UserDefaults.standard.bool(forKey: "isWeekly"),
                totalIncome: totIncome,
                totalExpense: totExpense,
                transactions: transactions
            )
            return transactionWrapper
        } else {
            print("ERROR: Database or Email is not set!")
            return nil
        }
    }
    
}

