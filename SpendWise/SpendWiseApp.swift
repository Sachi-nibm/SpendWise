//
//  SpendWiseApp.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-01.
//

import SwiftUI
import Firebase

@main
struct SpendWiseApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
