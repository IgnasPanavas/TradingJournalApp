//
//  TopPerformer.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 2/15/24.
//

import CoreData
import SwiftUI

struct TopPerformer: View {
    @Environment(\.theme) var theme
    var trade: AnyTrade
    var width: CGFloat
    
    var body: some View {

        HStack {
                   Text(trade.ticker)
                       .foregroundColor(theme.textColor)
                       .font(.headline)
                       .frame(width: width * 0.3, alignment: .leading) // Set a fixed width for the ticker
                   
                   formatPurchase(trade: trade)
                .frame(width: width * 0.4, alignment: .center) // Set a fixed width for the purchase information
                   
                   formatProfit(trade: trade)
                .frame(width: width * 0.3, alignment: .trailing) // Set a fixed width for the profit information
                }
                .frame(maxWidth: width)
                .padding()
                

   }
   
   private func formatPurchase(trade: AnyTrade) -> Text {
       let type = trade.tradeType
       let quantity = Int(trade.quantity)
       let formattedQuantity = NumberFormatter.localizedString(from: NSNumber(value: quantity), number: .decimal)
       var toReturn = "\(formattedQuantity) "
       
       switch type {
       case .stockTrade:
           toReturn.append("share")
       case .optionTrade:
           toReturn.append("contracts")
       case .futureTrade:
           toReturn.append("contracts")
       default:
           fatalError("Unhandled Trade Type")
       }
       
       toReturn.append(" @ \(trade.buyPrice)")
       return Text(toReturn)
           .foregroundColor(theme.textColor)
           .font(.subheadline)
   }
   
   private func formatProfit(trade: AnyTrade) -> Text {
       let profit = trade.calcProfit()
       let formattedProfit = NumberFormatter.localizedString(from: NSNumber(value: profit), number: .decimal)
       var color: Color
       
       if (profit > 0) {
           color = .green
       } else {
           color = .red
       }
       
       return Text("$\(formattedProfit)")
           .font(.title3)
           .foregroundColor(color)
   }
}

