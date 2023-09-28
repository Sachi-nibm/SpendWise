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
    
    @State var balanceStr = "10000.00"
    @State var currentTabIndex = 0
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentTabIndex) {
                HomeMainView()
                    .tag(0)
                
                AddTransactionView()
                    .tag(1)
            }
            .animation(.easeIn, value: currentTabIndex)
            .tabViewStyle(.page(indexDisplayMode: .never))
            //.border(Color.red)
            
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

struct HomeMainView: View {
    
    @State var balanceStr = "10000.00"
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                Text("AVAILABLE FUNDS")
                HStack {
                    Text("රු")
                        .multilineTextAlignment(.leading)
                        .font(.title)
                    Text(balanceStr)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                        .padding(.vertical, 10)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 15)
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 1)
                )
                .padding(.horizontal, 30)
                .padding(.top, -5)
            }
            .padding(.top, 5)
        }
    }
}

struct AddTransactionView: View {
    
    @State var balanceStr = "xxxxx.00"
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                Text("Add Transaction")
                HStack {
                    Text("රු")
                        .multilineTextAlignment(.leading)
                        .font(.title)
                    Text(balanceStr)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                        .padding(.vertical, 10)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 15)
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 1)
                )
                .padding(.horizontal, 30)
                .padding(.top, -5)
            }
            .padding(.top, 5)
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
