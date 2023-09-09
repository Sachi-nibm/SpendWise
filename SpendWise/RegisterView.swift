import Foundation

//
//  RegisterView.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-07.
//

import SwiftUI
import Firebase

struct RegisterView: View {
    
    @State var username: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    
    var body: some View {
        // Reference: https://stackoverflow.com/a/60374737
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
                        TextField("john@doe.com", text: $username)
                            .font(.title3)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
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
                        Auth.auth().createUser(withEmail: username, password: password) { (result, error) in
                            if let _error = error {
                                print(_error.localizedDescription )
                            }else{
                                print(result)
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
                    .padding(EdgeInsets(top: 25, leading: 50, bottom: 0, trailing: 50))
                    
                    NavigationLink {
                        RegisterView()
                    } label: {
                        NavigationLink(destination: RegisterView()) {
                            Text("Login to an Existing Account")
                                .bold()
                                .foregroundColor(.blue)
                                .padding(EdgeInsets(top: 10, leading: 0, bottom: 20, trailing: 0))
                        }
                    }
                }
                .frame(minHeight: geometry.size.height, maxHeight: .infinity, alignment: .center)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            }
            .frame(maxHeight: .infinity)
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
