//
//  TabTransactionHistory.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-28.
//

import SwiftUI

struct TabTransactionHistory: View {
    
    @State var balance = 3500
    @State var date = Date()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack(spacing: 5) {
                    Text("FROM")
                    DatePicker(selection: $date, in: ...Date.now, displayedComponents: .date) {
                        Text("Date")
                    }
                    .datePickerStyle(.compact)
                    .padding(.vertical, 2)
                    .labelsHidden()
                }
                Spacer()
                VStack(spacing: 5) {
                    Text("TO")
                    DatePicker(selection: $date, in: ...Date.now, displayedComponents: .date) {
                        Text("Date")
                    }
                    .datePickerStyle(.compact)
                    .padding(.vertical, 2)
                    .labelsHidden()
                }
                Spacer()
            }
            .padding(.vertical, 10)
            
            List {
                Section(
                    header:
                        HStack (spacing: 0) {
                            Text("July - Budget Adherence")
                                .foregroundColor(.black)
                            Spacer()
                            Text("100%")
                                .foregroundColor(.black)
                                .bold()
                        }
                        .padding(.bottom, 10)
                        .padding(.top, 4)
                        .padding(.horizontal, 10)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(10)
                ) {
                    HStack{
                        
                    }
                    .zIndex(2)
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: -100, trailing: 0))
                
                Section(header: Text("BB").frame(maxHeight: 0), footer: Text("").frame(maxHeight: 0)) {
                    HStack{
                        
                    }
                }
                .listRowInsets(EdgeInsets())
                .listStyle(.plain)
            }
        }
    }
}

struct TabTransactionHistory_Previews: PreviewProvider {
    static var previews: some View {
        TabTransactionHistory()
    }
}
