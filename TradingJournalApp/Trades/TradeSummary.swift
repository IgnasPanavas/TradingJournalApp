//
//  TradeSummary.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 2/11/24.
//

import CoreData
import SwiftUI

struct TradeSummary: View {
    var trade: OptionTrade
    
    
    var body: some View {
        VStack {
            HStack {
                Text(trade.ticker ?? "N/A")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Text("$\(calcProfit())")
                    .font(.title2)
            }
            .frame(width: 250)
            HStack {
                Text(formatPurchase())
                Spacer()
                Text(formatDate())
            }
            .frame(width: 250)
        }
        
    }
    func calcProfit() -> String {
        let profit = (trade.sPrice - trade.bPrice) * 100
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: profit)) ?? ""
    }
    func formatPurchase() -> String {
        let quantity: Int64 = trade.quantity
        var toReturn: String = "\(quantity)"

        if quantity >= 1 {

            toReturn.append(trade.callPut ? " calls" : " puts")
        } else {
            toReturn.append(trade.callPut ? " call" : " put")
        }
        toReturn.append(" @ \(trade.bPrice)")
        return toReturn
    }
    func formatDate() -> String {
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "MM.dd.yyyy"
        return dateFormatter.string(from: trade.date ?? Date())
    }

}

struct TradeSummary_Preview: PreviewProvider {
    static var previews: some View {
        // Ensure that the DataController is initialized and the view context is set up
        let context = DataController.shared.container.viewContext

        // Attempt to fetch an existing OptionTrade from the context
        let fetchRequest: NSFetchRequest<OptionTrade> = OptionTrade.fetchRequest()
        
        let result = try? context.fetch(fetchRequest)
        if let existingTrade = result?.first {
            // Pass the fetched trade to the TradeSummary view
            TradeSummary(trade: existingTrade)
        } else {
            // Fallback content in case no trades were found
            Text("No trades available")
        }
    }
}

