//
//  TabMainView.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-27.
//

import SwiftUI

struct TabMainView: View {
    
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
                
                Form {
                    
                }
            }
            .padding(.top, 5)
        }
    }
}

struct TabMainView_Previews: PreviewProvider {
    static var previews: some View {
        TabMainView()
    }
}
