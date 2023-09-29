import Foundation

//
//  RegisterView.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-07.
//

import SwiftUI

struct RegisterView: View {
    
    @ObservedObject var userViewModel = UserViewModel()
    
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
                    Text("Register")
                        .font(.subheadline)
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    
                    Group{
                        Text("Email")
                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("john@doe.com", text: $userViewModel.email)
                            .font(.title3)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("Password")
                            .padding(EdgeInsets(top: 15, leading: 10, bottom: 0, trailing: 10))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        SecureField("•••••••", text: $userViewModel.password)
                            .font(.title3)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Text("Confirm Password")
                            .padding(EdgeInsets(top: 15, leading: 10, bottom: 0, trailing: 10))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        SecureField("•••••••", text: $userViewModel.confirmPassword)
                            .font(.title3)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    Button() {
                        userViewModel.register()
                    } label: {
                        if (userViewModel.isLoading) {
                            ProgressView()
                                .tint(.primary)
                                .padding(.horizontal, 50)
                                .padding(.vertical, 10)
                                .font(.title3)
                        } else {
                            Text("REGISTER")
                                .font(.title3)
                                .frame(maxWidth: .infinity)
                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                                .bold()
                        }
                    }
                    .buttonStyle(.bordered)
                    .tint(.blue)
                    .cornerRadius(.infinity)
                    .padding(EdgeInsets(top: 25, leading: 50, bottom: 20, trailing: 50))
                    .alert(isPresented: $userViewModel.showAlert) {
                        Alert(title: Text("ERROR"), message: Text(userViewModel.errorMessage), dismissButton: .default(Text("OK")))
                    }
                }
                .frame(minHeight: geometry.size.height, maxHeight: .infinity, alignment: .center)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            }
            .frame(maxHeight: .infinity)
        }
        .animation(.easeIn, value: userViewModel.isLoading)
        .navigationBarTitle("Create Account", displayMode: .inline)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
