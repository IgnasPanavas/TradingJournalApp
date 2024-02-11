//
//  TradeLogView.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 2/6/24.
//

import SwiftUI
import CoreData

struct TradeLogView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    // FetchRequest with sorting by date
    @FetchRequest(
        entity: OptionTrade.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \OptionTrade.date, ascending: true)]
        // Set to false if you want descending order
    ) var optionTrades: FetchedResults<OptionTrade>
    
    var body: some View {
        VStack {
            Text("Recent Trades")
                .font(.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding([.top], 50)
            NavigationStack {
                    ForEach(optionTrades) { trade in
                        TradeSummary(trade: trade)
                            .padding()
                    }
                }
            
        }
    }
}

// Assuming you have a DateFormatter to format the tradeDate for display
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .short
    return formatter
}()

struct TradeLogView_Previews: PreviewProvider {
    static var previews: some View {
        TradeLogView().environment(\.managedObjectContext, DataController.shared.container.viewContext)
            
    }
}
