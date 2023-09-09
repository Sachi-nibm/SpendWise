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
        NavigationView {
            LoginView()
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
