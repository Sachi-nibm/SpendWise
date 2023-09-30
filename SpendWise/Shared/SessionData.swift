//
//  SharedData.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-19.
//

import Foundation
import Firebase
import SwiftUI

// Class which is used as environment variable
class SessionData: ObservableObject {
    
    // Store default display type in UserDefault dictionary
    @AppStorage("isWeekly") var isWeekly = true
    
    @Published var currentUser: User?
    @Published var transactions: TransactionWrapper?
    
    @Published var applicationInitializing = true
    @Published var showBaseError = false
    @Published var baseErrorMsg = ""
    
    @Published var isLoading = true
    
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    
    init() {
        print("--INIT")
        addAuthStateListener()
    }
    
    deinit {
        print("--DEINIT")
        removeAuthStateListener()
    }
    
    // Listen for user login logout changes. Also handle automatic login
    func addAuthStateListener() {
        isLoading = true
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { (_, user) in
            if let email = user?.email {
                FireStoreUtil.assignEmail(email: email)
                FireStoreUtil.loadDataObjects(email) { user, transactions, error in
                    if let error = error {
                        DispatchQueue.main.async {
                            self.showBaseError = true
                            self.baseErrorMsg = error.localizedDescription
                            self.isLoading = false
                        }
                    } else if let user = user {
                        DispatchQueue.main.async {
                            self.transactions = transactions
                            self.currentUser = user
                        }
                    } else {
                        print("Unexpected error!")
                    }
                    Task {
                        try await Task.sleep(nanoseconds: 1_500_000_000)
                        DispatchQueue.main.async {
                            self.applicationInitializing = false
                        }
                    }
                }
            } else {
                FireStoreUtil.removeEmail()
                self.isLoading = false
                Task {
                    try await Task.sleep(nanoseconds: 2_500_000_000)
                    DispatchQueue.main.async {
                        self.applicationInitializing = false
                    }
                }
            }
        }
    }
    
    // Remove the listener on destroy to save resources
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
    
    // Check if user has created a budget
    func isUserInitialized() -> Bool {
        if let user = currentUser {
            return !user.categories.isEmpty
        } else {
            return false
        }
    }
    
    // Reload user data from firebase
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
    
    // Get user selected colour for category
    func getColorForCategoryCode(_ code: String) -> Color {
        var colour = Color.gray
        for cat in currentUser?.categories ?? [] {
            if cat.id == code {
                colour = CategoryData.categoryColors[cat.colourCode] ?? colour
                break
            }
        }
        return colour
    }
    
}
