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
    
    @EnvironmentObject var sessionData: SessionData
    @State var currentTabIndex = 0
    
    var body: some View {
        
        // Main tabview used for home
        VStack(spacing: 0) {
            TabView(selection: $currentTabIndex) {
                
                TabMainView()
                    .tag(0)
                
                TabAddTransactionView()
                    .tag(1)
                
                TabTransactionHistoryView()
                    .tag(2)
                
                TabSettingsView()
                    .tag(3)
                
            }
            .animation(.easeIn, value: currentTabIndex)
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // Custom navigation bar is used as slidable navigation view does not have a navigation bar
            HStack {
                Spacer()
                VStack(spacing: 5) {
                    Image(systemName: "house.fill")
                    Text("Home")
                        .font(.caption)
                }
                .onTapGesture {
                    currentTabIndex = 0
                }
                .foregroundColor(currentTabIndex == 0 ? .blue : .gray)
                Spacer()
                VStack(spacing: 5) {
                    Image(systemName: "plus.forwardslash.minus")
                    Text("Add New")
                        .font(.caption)
                }
                .onTapGesture {
                    currentTabIndex = 1
                }
                .foregroundColor(currentTabIndex == 1 ? .blue : .gray)
                Spacer()
                VStack(spacing: 5) {
                    Image(systemName: "arrow.left.arrow.right")
                    Text("History")
                        .font(.caption)
                }
                .onTapGesture {
                    currentTabIndex = 2
                }
                .foregroundColor(currentTabIndex == 2 ? .blue : .gray)
                Spacer()
                VStack(spacing: 5) {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                        .font(.caption)
                }
                .onTapGesture {
                    currentTabIndex = 3
                }
                .foregroundColor(currentTabIndex == 3 ? .blue : .gray)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.top)
            .background(
                Color(.secondarySystemFill).edgesIgnoringSafeArea(.all)
            )
        }
        .onAppear() {
            // Reload data on appear of home
            sessionData.reloadUserData() { error in
                if let _ = error {
                    print("Error in data reload!")
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
        }
    }
}
