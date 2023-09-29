//
//  TabSettingsView.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-29.
//

import SwiftUI

struct TabSettingsView: View {
    
    @EnvironmentObject var sessionData: SessionData
    
    @State var budget = "month"
    @State var showingAlert = false
    
    var body: some View {
        VStack {
            Form {
                Section(
                    header:
                        Text("example@gmail.co")
                        .textCase(.none)
                        .font(.title3)
                        .frame(maxWidth: .infinity)
                        .tint(.primary)
                        .bold()
                    ,
                    content: {}
                )
                .padding(.top)
                
                //                Section(content: {
                //                    HStack{
                //                        Image(systemName: "tray.2")
                //                        Text("Category Settings")
                //                        Spacer()
                //                        Image(systemName: "chevron.forward")
                //                    }
                //                })
                
                Section(content: {
                    HStack{
                        Image(systemName: "calendar.badge.clock")
                        Text("Budget Period")
                        Spacer()
                        Picker("", selection: $budget) {
                            Text("Monthly")
                                .tag("month")
                            Text("Weekly")
                                .tag("week")
                        }
                        .labelsHidden()
                        .pickerStyle(.menu)
                        .onChange(of: budget, perform: { value in
                            if value == "week" {
                                sessionData.isWeekly = true
                            } else {
                                sessionData.isWeekly = false
                            }
                            sessionData.reloadUserData() { error in
                                if let _ = error {
                                    print("Error in data reload!")
                                }
                            }
                        })
                    }
                })
            }
            HStack {
                Button() {
                    showingAlert = true
                } label: {
                    Text("Logout")
                        .padding(.leading)
                    Label("", systemImage: "rectangle.portrait.and.arrow.right")
                }
                .buttonStyle(.bordered)
                .tint(.red)
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .alert(isPresented:$showingAlert) {
            Alert(
                title: Text("Logout"),
                message: Text("Are you sure you want to logout?"),
                primaryButton: .destructive(Text("Logout")) {
                    sessionData.logOut() { completion in
                        if let completion = completion {
                            print("ERROR: \(completion)")
                        }
                    }
                },
                secondaryButton: .cancel()
            )
        }
        .onAppear() {
            self.budget = sessionData.isWeekly ? "week" : "month"
        }
    }
}

struct TabSettings_Previews: PreviewProvider {
    static var previews: some View {
        TabSettingsView()
    }
}
