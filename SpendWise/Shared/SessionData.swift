//
//  SharedData.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-19.
//

import Foundation
import Firebase

class SessionData: ObservableObject {
    
    @Published var currentUser: User?
    
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
                FireStoreUtil.loadDataObjects() { data, error in
                    if let error = error {
                        print(error)
                    } else {
                        let user = User(id: email, categories: data)
                        self.currentUser = user
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
