//
//  ContentView.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-01.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var sessionData = SessionData()
    
    var body: some View {
        NavigationView {
            if (sessionData.isUserLoggedIn()) {
                if (sessionData.isUserInitialized()) {
                    HomeView()
                } else {
                    BudgetSetupView()
                }
            } else {
                LoginView()
            }
        }
        .environmentObject(sessionData)
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
