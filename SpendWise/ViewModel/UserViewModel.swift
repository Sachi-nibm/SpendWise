//
//  UserViewModel.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-15.
//

import Foundation
import Firebase

class UserViewModel: ObservableObject {
    
    @Published private var currentUser: User?
    
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
                let user = User(id: email)
                self.currentUser = user
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
    
    // Will only get called after logged in. Otherwise an error will be thrown
    func getUserEmail() -> String {
        return currentUser!.id;
    }
    
    func register(email: String, password: String, confirmPassword: String, completion: @escaping (String?) -> Void) {
        let emailValidator = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}")
        let emailValid = emailValidator.evaluate(with: email)
        if (!emailValid) {
            completion("Email is invalid. Please enter a valid email!")
        } else if (password.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
                completion("Password is empty. Please enter a valid password!")
        } else if let _ = password.rangeOfCharacter(from: .whitespacesAndNewlines) {
            completion("Password is invalid. Password cannot contain whitespaces!")
        } else if (password != confirmPassword) {
            completion("Password and Confirm Password does not match. Please enter same phrase for both fields!")
        } else {
            // Reference https://stackoverflow.com/a/71917649
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let err = error as NSError? {
                    let errCode = AuthErrorCode(_nsError: err)
                    switch errCode.code {
                    case .accountExistsWithDifferentCredential, .credentialAlreadyInUse, .emailAlreadyInUse:
                        completion("Account already exists. Please login!")
                    default:
                        completion(err.localizedDescription)
                    }
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    func logUserIn(email: String, password: String, completion: @escaping (String?) -> Void) {
        let emailValidator = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}")
        let emailValid = emailValidator.evaluate(with: email)
        if (!emailValid) {
            completion("Email is invalid. Please enter a valid email!")
        } else if (password.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            completion("Password is empty. Please enter a valid password!")
        } else {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let err = error as NSError? {
                    let errCode = AuthErrorCode(_nsError: err)
                    switch errCode.code {
                    case .wrongPassword:
                        completion("Password is incorrect. Please try again.")
                    default:
                        completion(err.localizedDescription)
                    }
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    func logOut(completion: @escaping (String?) -> Void) {
        do {
            try Auth.auth().signOut()
            currentUser = nil
            completion(nil)
        } catch let signOutError as NSError {
            completion("Error occurred. Please try again later.")
        }
    }
    
}
