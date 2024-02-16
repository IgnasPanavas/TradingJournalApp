//
//  TopPerformer.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 2/15/24.
//

import CoreData
import SwiftUI

struct TopPerformer: View {
    
    var trade: OptionTrade
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(Color.black.opacity(0.5))
                .frame(width: 350, height: 60)
            HStack {
                Text(trade.ticker ?? "")
                    .foregroundStyle(Color.white)
                Spacer()
                Text(formatPurchase())
                    .foregroundStyle(Color.white)
                Spacer()
                calcProfit()
                    
                
            }
            .frame(width: 300, height: 80)
                
        }
    }
    func formatPurchase() -> String {
        let quantity: Int64 = trade.quantity
        var toReturn: String = "\(quantity)"

        if quantity > 1 {

            toReturn.append(trade.callPut ? " calls" : " puts")
        } else {
            toReturn.append(trade.callPut ? " call" : " put")
        }
        toReturn.append(" @ \(trade.bPrice)")
        return toReturn
    }
    func calcProfit() -> Text {
        var toReturn: String = "$"
        let profit = (trade.sPrice - trade.bPrice) * 100 * Double(trade.quantity)
        var color: Color
        
        if (profit > 0) {
            color = .green
        } else {
            color = .red
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        toReturn.append(formatter.string(from: NSNumber(value: profit)) ?? "")
        return Text(toReturn)
            .font(.title3)
            .foregroundStyle(color)
    }
}

struct TopPerformer_Preview: PreviewProvider {
    static var previews: some View {
        let context = DataController.shared.container.viewContext

        // Attempt to fetch an existing OptionTrade from the context
        let fetchRequest: NSFetchRequest<OptionTrade> = OptionTrade.fetchRequest()
        
        let result = try? context.fetch(fetchRequest)
        if let existingTrade = result?.first {
            // Pass the fetched trade to the TradeSummary view
            TopPerformer(trade: existingTrade)
        } else {
            // Fallback content in case no trades were found
            Text("No trades available")
        }
    }
    
}
