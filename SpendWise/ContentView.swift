//
//  ContentView.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-01.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    @State var isLoggedIn: Bool = false;
    
    var body: some View {
        NavigationView {
            if (isLoggedIn) {
                HomeView()
            } else {
                LoginView()
            }
        }
        .onAppear(perform: {
            Auth.auth().addStateDidChangeListener() { auth, user in
                if user != nil {
                    print(user?.email!)
                    isLoggedIn = true
                } else {
                    isLoggedIn = false
                }
            }
        })
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
