//
//  SplashScreenView.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-30.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isRotating = 0.0
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            Image("spendWise")
                .resizable()
                .frame(width: 150, height: 150)
                .aspectRatio(contentMode: .fit)
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
            Spacer()
            Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.blue)
                .rotationEffect(.degrees(isRotating))
            Text("Fetching Data")
                .padding(.top, 5)
            Spacer()
            Spacer()
        }
        .onAppear {
            // Add a rotating animation for the icon
            withAnimation(.linear(duration: 3)
                .repeatForever(autoreverses: false)) {
                    isRotating = 360.0
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
