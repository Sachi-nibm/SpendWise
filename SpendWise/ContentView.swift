//
//  ContentView.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-01.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var userViewModel = UserViewModel()
    
    var body: some View {
        NavigationView {
            if (userViewModel.isUserLoggedIn()) {
                HomeView()
            } else {
                LoginView()
            }
        }
        .environmentObject(userViewModel)
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
