//
//  UserViewModel.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-15.
//

import SwiftUI
import Firebase

class UserViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""
    
    func register() {
        let emailValidator = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}")
        let emailValid = emailValidator.evaluate(with: email)
        if (!emailValid) {
            errorMessage = ("Email is invalid. Please enter a valid email!")
            showAlert = true
        } else if (password.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            errorMessage = ("Password is empty. Please enter a valid password!")
            showAlert = true
        } else if let _ = password.rangeOfCharacter(from: .whitespacesAndNewlines) {
            errorMessage = ("Password is invalid. Password cannot contain whitespaces!")
            showAlert = true
        } else if (password != confirmPassword) {
            errorMessage = ("Password and Confirm Password does not match. Please enter same phrase for both fields!")
            showAlert = true
        } else {
            // Reference https://stackoverflow.com/a/71917649
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let err = error as NSError? {
                    let errCode = AuthErrorCode(_nsError: err)
                    switch errCode.code {
                    case .accountExistsWithDifferentCredential, .credentialAlreadyInUse, .emailAlreadyInUse:
                        self.errorMessage = ("Account already exists. Please login!")
                        self.showAlert = true
                    default:
                        self.errorMessage = (err.localizedDescription)
                        self.showAlert = true
                    }
                } else {
                    // completion(nil)
                }
            }
        }
    }
    
    func logUserIn() {
        let emailValidator = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}")
        let emailValid = emailValidator.evaluate(with: email)
        if (!emailValid) {
            errorMessage = ("Email is invalid. Please enter a valid email!")
            showAlert = true
        } else if (password.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            errorMessage = ("Password is empty. Please enter a valid password!")
            showAlert = true
        } else {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let err = error as NSError? {
                    let errCode = AuthErrorCode(_nsError: err)
                    switch errCode.code {
                    case .wrongPassword:
                        self.errorMessage = ("Password is incorrect. Please try again.")
                        self.showAlert = true
                    default:
                        self.errorMessage = (err.localizedDescription)
                        self.showAlert = true
                    }
                } else {
                    //completion(nil)
                }
            }
        }
    }
    
}
