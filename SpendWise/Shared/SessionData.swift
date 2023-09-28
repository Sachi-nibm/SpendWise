//
//  SharedData.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-19.
//

import Foundation
import Firebase
import SwiftUI

class SessionData: ObservableObject {
    
    @AppStorage("isWeekly") var isWeekly = true
    
    @Published var currentUser: User?
    @Published var transactions: TransactionWrapper?
    
    @Published var showBaseError = false
    @Published var baseErrorMsg = ""
    
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    
    init() {
        print("--INIT")
        addAuthStateListener()
    }
    
    deinit {
        print("--DEINIT")
        removeAuthStateListener()
    }
    
    func addAuthStateListener() {
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { (_, user) in
            if let email = user?.email {
                FireStoreUtil.assignEmail(email: email)
                FireStoreUtil.loadDataObjects(email) { user, transactions, error in
                    if let error = error {
                        print(error)
                        print("__AA__")
                        DispatchQueue.main.async {
                            self.showBaseError = true
                            self.baseErrorMsg = error.localizedDescription
                        }
                    } else if let user = user {
                        self.transactions = transactions
                        self.currentUser = user
                    } else {
                        print("Unexpected error!")
                    }
                }
            } else {
                FireStoreUtil.removeEmail()
            }
        }
    }
    
    func removeAuthStateListener() {
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func isUserLoggedIn() -> Bool {
        if let user = currentUser {
            print("Session Found: " + user.id)
            return (user.id != "")
        } else {
            print("No Session")
            return false
        }
    }
    
    func isUserInitialized() -> Bool {
        if let user = currentUser {
            print(user.categories)
            print(!user.categories.isEmpty)
            return !user.categories.isEmpty
        } else {
            return false
        }
    }
    
    func reloadUserData(completion: @escaping (Error?) -> Void) {
        if let email = currentUser?.id {
            FireStoreUtil.loadDataObjects(email) { user, transactions, error in
                if let error = error {
                    completion(error)
                } else if let user = user {
                    self.transactions = transactions
                    self.currentUser = user
                    completion(nil)
                } else {
                    completion(SpendWiseError.runtimeError("Unexpected error!"))
                }
            }
        }
    }
    
    func logOut(completion: @escaping (String?) -> Void) {
        do {
            try Auth.auth().signOut()
            currentUser = nil
            completion(nil)
        } catch _ as NSError {
            completion("Error occurred. Please try again later.")
        }
    }
    
}
