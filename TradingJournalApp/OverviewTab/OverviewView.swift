//
//  OverviewView.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 2/13/24.
//

import CoreData
import SwiftUI

struct OverviewView: View {
    
    @FetchRequest(
        entity: OptionTrade.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \OptionTrade.date, ascending: false)],
        predicate: NSPredicate(format: "date >= %@ AND date < %@", argumentArray: [Calendar.current.startOfDay(for: Date()), Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: Date())) as Any])
    ) var optionTrades: FetchedResults<OptionTrade>
    
    var body: some View {
        
        VStack {
            Text("Overview")
            HStack {
                //MARK: P/L Day rectangle
                ZStack {
                    Rectangle()
                        .cornerRadius(10)
                        .frame(width: 135, height: 135)
                        .overlay(Rectangle()
                            .fill(Color(.white))
                            .cornerRadius(7)
                            .frame(width: 130, height: 130))
                    VStack {
                        profitLossDay()
                            .padding()
                        Text("P/L Day")
                    }
                    
                    
                    
                }
                ZStack {
                    Rectangle()
                        .cornerRadius(10)
                        .frame(width: 135, height: 135)
                        .overlay(Rectangle()
                            .fill(Color(.white))
                            .cornerRadius(7)
                            .frame(width: 130, height: 130))
                    VStack {
                        numOfTrades()
                            .padding()
                        Text("# of Trades")
                    }
                }
                
                
            }
            Spacer()
        }
    }
    func profitLossDay() -> Text {
        var toReturn: String = ""
        var profitLoss: Double = 0;
        var color: Color = .green
        for trade in optionTrades {
                profitLoss += (trade.sPrice - trade.bPrice) * 100 * Double(trade.quantity)
            }
        toReturn = String(format: "%@%.2f", profitLoss >= 0 ? "+" : "", profitLoss)
        if (profitLoss < 0) {
            color = .red
        }
        return Text(toReturn)
            .foregroundStyle(Color(color))
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
        
    }
    
    func numOfTrades() -> Text {
        let numTrades: Int = optionTrades.count
        return Text("\(numTrades)")
            .font(.title)
    }
}

struct OverviewView_Preview: PreviewProvider {
    static var previews: some View {
        OverviewView()
            .environment(\.managedObjectContext, DataController.shared.container.viewContext)
    }
}
