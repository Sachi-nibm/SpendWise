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
        let modEmail = email.replacingOccurrences(of: "[.#$\\[\\]]", with: "", options: .regularExpression, range: nil)
        FireStoreUtil.email = modEmail
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
    
    static func loadDataObjects(completion: @escaping ([String], Error?) -> Void) {
        loadDataFromFirebase(completion:  { snapshot, error in
            print(snapshot, error)
            if let error = error {
                completion([], error)
            } else {
                if let snapshot = snapshot {
                    let categoriesSnapshot = snapshot.childSnapshot(forPath: "categories")
                    let stringArray = categoriesSnapshot.value as? [String]
                    completion(stringArray ?? [], nil)
                } else {
                    completion([], nil)
                }
            }
        });
    }
    
}

enum SpendWiseError: Error {
    case runtimeError(String)
}

