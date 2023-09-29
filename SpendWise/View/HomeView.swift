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
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
        }
    }
}
