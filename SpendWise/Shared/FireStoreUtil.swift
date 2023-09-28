//
//  FireStoreUtil.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-20.
//

import Foundation
import FirebaseDatabase

class FireStoreUtil {
    
    private static var email: String?
    static var ref: DatabaseReference?
    
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
    
    static func loadDataObjects(_ userEmail: String, completion: @escaping (User?, Error?) -> Void) {
        loadDataFromFirebase(completion:  { snapshot, error in
            if let error = error {
                completion(nil, error)
            } else {
                if let snapshot = snapshot {
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
                        }
                        categories.append(category)
                    }
                    let user = User(id: userEmail, categories: categories, balance: balance)
                    completion(user, nil)
                } else {
                    completion(nil, nil)
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
    
}

