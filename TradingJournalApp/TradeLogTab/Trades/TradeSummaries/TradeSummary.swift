//
//  TradeSummary.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 2/11/24.
//

import CoreData
import SwiftUI
import UIKit

struct TradeSummary: View {
    var trade: OptionTrade
    @State private var translation: CGSize = .zero
    @State private var showEditTradeView = false
    @AppStorage("dateFormat") var dateFormat: String = "MM/dd/yyyy"
    @AppStorage("timeFormat") var timeFormat: String = "HH:mm"
    @AppStorage("showDecimalPlaces") var showDecimalPlaces: Bool = true

    let threshold: CGFloat = 150
    
    var body: some View {
            ZStack {
                Rectangle()
                    .fill(Color.black)
                    
                    // Assuming you have styling here

                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text(trade.ticker ?? "N/A")
                            .font(.subheadline) // Reduced font size
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Spacer()
                        calcProfit()
                            .font(.subheadline)
                    }

                    HStack(spacing: 10) {
                        Text(formatPurchase()) // Condensed formatting
                            .font(.caption2)
                            .lineLimit(1)
                            .foregroundColor(.white)
                        Spacer()
                        Text(formatDate()) // Consider further reducing date format
                            .font(.caption2)
                            .foregroundColor(.white)
                    }
                }.padding(.horizontal, 8) // Reduced padding
                
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        withAnimation {
                            if (gesture.translation.width < 0) {
                                self.translation = gesture.translation
                                if abs(gesture.translation.width) > threshold {
                                    self.showEditTradeView = true
                                    self.translation = .zero
                                }
                            }
                        }
                    }
                    .onEnded { gesture in
                        withAnimation {
                            if abs(gesture.translation.width) <= threshold {
                                // Reset translation and editing state
                                self.translation = .zero
                                self.showEditTradeView = false
                            }
                        }
                    }
            )
            .offset(x: translation.width, y: 0)
            .animation(.easeInOut)
            .sheet(isPresented: $showEditTradeView) {
                EditOptionTradeView(tradeToEdit: trade)
                    
            }
        }
            }
        
    func calcProfit() -> Text {
        let profit = (trade.sellPrice - trade.buyPrice) * 100 * Double(trade.quantity)
        let color: Color = profit > 0 ? .green : .red
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$" // Assuming USD, adjust as needed
        formatter.minimumFractionDigits = showDecimalPlaces ? 2 : 0
        formatter.maximumFractionDigits = showDecimalPlaces ? 2 : 0
        
        return Text(formatter.string(from: NSNumber(value: profit)) ?? "")
            .foregroundStyle(color)
    }
    func formatPurchase() -> String {
        let quantity: Int64 = trade.quantity
        var toReturn: String = "\(quantity)"

        if quantity > 1 {

            toReturn.append(trade.callPut ? " calls" : " puts")
        } else {
            toReturn.append(trade.callPut ? " call" : " put")
        }
        toReturn.append(" @ \(trade.buyPrice)")
        return toReturn
    }
    func formatDate() -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = dateFormat // Use selected dateFormat
           return dateFormatter.string(from: trade.date ?? Date())
       }
}

