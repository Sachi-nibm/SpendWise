import Foundation

//
//  RegisterView.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-07.
//

import SwiftUI

struct RegisterView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    
    @State var showAlert: Bool = false
    @State var showSuccess: Bool = false
    @State var errorMessage: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image("spendWise")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .aspectRatio(contentMode: .fit)
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                    
                    Text("Spend Wise, Live Smart!")
                        .font(.title2)
                        .italic()
                        .bold()
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    Text("your personal budget planner")
                        .font(.subheadline)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    Text("Please register for a more personalised experience")
                        .font(.subheadline)
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    
                    Group{
                        Text("Email")
                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("john@doe.com", text: $email)
                            .font(.title3)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("Password")
                            .padding(EdgeInsets(top: 15, leading: 10, bottom: 0, trailing: 10))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        SecureField("•••••••", text: $password)
                            .font(.title3)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("Confirm Password")
                            .padding(EdgeInsets(top: 15, leading: 10, bottom: 0, trailing: 10))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        SecureField("•••••••", text: $confirmPassword)
                            .font(.title3)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    Button() {
                        userViewModel.register(email: email, password: password, confirmPassword: confirmPassword) { message in
                            if let message = message {
                                errorMessage = message
                                showAlert = true
                            } else {
                                // register was successful
                            }
                        }
                    } label: {
                        Text("REGISTER")
                            .font(.title3)
                            .frame(maxWidth: .infinity)
                            .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                            .bold()
                    }
                    .buttonStyle(.bordered)
                    .tint(.blue)
                    .cornerRadius(.infinity)
                    .padding(EdgeInsets(top: 25, leading: 50, bottom: 20, trailing: 50))
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("ERROR"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                    }
                    .alert(isPresented: $showSuccess) {
                        Alert(title: Text("SUCCESS"), message: Text("User created successfully. Please login."), dismissButton: .default(Text("OK")))
                    }
                }
                .frame(minHeight: geometry.size.height, maxHeight: .infinity, alignment: .center)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            }
            .frame(maxHeight: .infinity)
        }
        .navigationBarTitle("Create Account", displayMode: .inline)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
