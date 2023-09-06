//
//  ContentView.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-01.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    @State var username: String = ""
    @State var password: String = ""
    
    var body: some View {
        // Reference: https://stackoverflow.com/a/60374737
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image("spendWise")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .aspectRatio(contentMode: .fit)
                    
                    Text("Spend Wise, Live Smart!")
                        .font(.title2)
                        .italic()
                        .bold()
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    Text("your personal budget planner")
                        .font(.subheadline)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    Text("Please login for a more personalised experience")
                        .font(.subheadline)
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                    
                    Text("Email")
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("john@doe.com", text: $username)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("Password")
                        .padding(EdgeInsets(top: 15, leading: 20, bottom: 0, trailing: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    SecureField("•••••••", text: $password)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button() {
                        Auth.auth().signIn(withEmail: username, password: password) { (result, error) in
                            if error != nil {
                                print(error)
                                print(error?.localizedDescription ?? "")
                            } else {
                                print(result)
                                print("success")
                            }
                        }
                    } label: {
                        Text("LOGIN")
                            .font(.title3)
                            .frame(maxWidth: .infinity)
                            .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                            .bold()
                    }
                    .buttonStyle(.bordered)
                    .tint(.blue)
                    .cornerRadius(.infinity)
                    .padding(EdgeInsets(top: 25, leading: 50, bottom: 0, trailing: 50))
                    
                    Button() {
                        
                    } label: {
                        Text("Create an Account")
                            .bold()
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.blue)
                    .cornerRadius(.infinity)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                }
                .frame(minHeight: geometry.size.height, maxHeight: .infinity, alignment: .center)
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
            }
            .frame(maxHeight: .infinity)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
