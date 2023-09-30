//
//  ContentView.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-01.
//

import SwiftUI

struct ContentView: View {
    
    // Initialise object for environment variable
    @StateObject var sessionData = SessionData()
    
    var body: some View {
        
        // Allow navigation between views
        NavigationView {
            
            // Present different views depending on conditions.
            // These set as root view of navigation
            if sessionData.applicationInitializing {
                SplashScreenView()
            } else if (sessionData.isUserLoggedIn() && sessionData.isUserInitialized()) {
                HomeView()
            } else if (sessionData.isUserLoggedIn()) {
                BudgetSetupView()
            } else {
                LoginView()
            }
        }
        .environmentObject(sessionData)
        .alert(isPresented: $sessionData.showBaseError) {
            Alert(
                title: Text("ERROR"),
                message: Text(sessionData.baseErrorMsg),
                dismissButton: .default(Text("OK")))
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
