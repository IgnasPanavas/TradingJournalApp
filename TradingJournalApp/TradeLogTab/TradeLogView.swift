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
    
    @State private var showingAddTrade = false
    
    // FetchRequest with sorting by date
    @FetchRequest(
        entity: OptionTrade.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \OptionTrade.date, ascending: false)]
        // Set to false if you want descending order
    ) var optionTrades: FetchedResults<OptionTrade>
    
    var closedTrades: [OptionTrade] {
        optionTrades.filter { $0.closed }
    }

    var openTrades: [OptionTrade] {
        optionTrades.filter { !$0.closed }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Image("TradeScreen-Background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Recent Trades")
                        .font(.title)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding([.top, .bottom], 20)
                        .foregroundStyle(.white)
                    
                    VStack {
                        Text("Ongoing")
                            .foregroundStyle(.white)
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.leading], 40)
                        
                        ForEach(openTrades) { trade in
                            Divider()
                                .background(.white)
                            TradeSummary(trade: trade)
                                .padding()
                            
                        }
                        
                    }
                    .padding([.bottom], 50)
                    
                    VStack {
                        Text("Closed")
                            .font(.title)
                            .opacity(0.5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.white)
                            .padding([.leading], 40)
                        
                        
                        ForEach(closedTrades) { trade in
                            Divider()
                                .background(.white)
                            TradeSummary(trade: trade)
                                .padding()
                                .opacity(0.5)
                            
                        }
                        
                    }
                    
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddTrade.toggle() // This toggles the state variable
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white) // Changed to `.foregroundColor`
                    }
                    .sheet(isPresented: $showingAddTrade) {
                        AddTrade()
                    }
                }
            }

            
        }
    }
}
    


struct TradeLogView_Previews: PreviewProvider {
    static var previews: some View {
        TradeLogView().environment(\.managedObjectContext, DataController.shared.container.viewContext)
            
            
    }
}
