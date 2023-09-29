//
//  TabMainView.swift
//  SpendWise
//
//  Created by Sachini Perera on 2023-09-27.
//

import SwiftUI

struct TabMainView: View {
    
    @EnvironmentObject var sessionData: SessionData
    
    @State var minValue = 0
    @State var maxValue = 100
    let gradient = Gradient(colors: [.green, .green, .green, .green, .yellow, .orange, .red])
    
    var body: some View {
        VStack {
            Text("AVAILABLE FUNDS")
            HStack {
                Text("Rs")
                    .multilineTextAlignment(.leading)
                    .font(.title)
                Text(String(format: "%.2f", (sessionData.currentUser?.balance ?? 0)))
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
            
            GeometryReader { geometry in
                ScrollView(.vertical) {
                    VStack {
                        ForEach(sessionData.currentUser?.categories ?? [], id: \.id) { category in
                            let expense = sessionData.transactions?.expenseForCategory[category.id] ?? 0
                            let gaugeVal = calcPercentage(category.budget, expense)
                            HStack {
                                Gauge(
                                    value: gaugeVal,
                                    in: 0...100,
                                    label: { Text("Gauge Label") },
                                    currentValueLabel: {
                                        HStack(spacing: 0) {
                                            Text("\(Int(gaugeVal))")
                                                .padding(0)
                                            Text("%")
                                                .padding(0)
                                                .font(.caption)
                                        }
                                    },
                                    minimumValueLabel: { Text("0") },
                                    maximumValueLabel: { Text("100") }
                                )
                                .scaleEffect(1.4)
                                .frame(width: 80, height: 80)
                                .tint(gradient)
                                .gaugeStyle(.accessoryCircular)
                                
                                Spacer()
                                VStack {
                                    VStack {
                                        Text(category.label)
                                            .textCase(.uppercase)
                                            .bold()
                                            .padding(.bottom, 1)
                                        HStack(spacing: 0) {
                                            Text("Available : ")
                                                .font(.subheadline)
                                            Text("Rs \((category.budget == 0) ? "N/A" : String(format: "%.0f", (category.budget - expense)))")
                                                .font(.subheadline)
                                                .bold()
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    VStack(spacing: 0) {
                                        HStack(spacing: 0) {
                                            Text("Budget : ")
                                                .font(.caption)
                                            Text("Rs \((category.budget == 0) ? "N/A" : String(format: "%.0f", category.budget))")
                                            .font(.caption)
                                            .bold()
                                        }
                                        HStack(spacing: 0) {
                                            Text("Spent : ")
                                                .font(.caption)
                                            Text("Rs " + String(format: "%.0f", expense))
                                                .font(.caption)
                                                .bold()
                                        }
                                    }
                                }
                                .padding(.leading, 5)
                            }
                            .padding(.all, 10)
                            .background((gaugeVal > 90) ? Color.red.opacity(0.1) : nil)
                            .background(Color(.systemBackground))
                            .cornerRadius(20)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: geometry.size.height, maxHeight: .infinity, alignment: .center)
                    .padding(.vertical, 10)
                    .background(Color(.quaternarySystemFill))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .padding(.top, 5)
    }
    
    func calcPercentage(_ budget: Double, _ expense: Double) -> Double {
        if budget == 0 {
            return 0
        } else {
            let value = ((expense * 100) / budget)
            if value > 100 {
                return 100
            } else {
                return value
            }
        }
    }
}

struct TabMainView_Previews: PreviewProvider {
    static var previews: some View {
        TabMainView()
    }
}
