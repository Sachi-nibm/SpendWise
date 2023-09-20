//
//  HomeView.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-12.
//

import Foundation

import SwiftUI
import Firebase

struct HomeView: View {
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                }
            }
        }
        .navigationTitle("HOME")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
