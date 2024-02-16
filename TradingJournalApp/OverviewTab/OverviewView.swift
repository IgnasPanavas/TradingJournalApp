//
//  OverviewView.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 2/13/24.
//

import CoreData
import SwiftUI

struct OverviewView: View {
    var weeklyPT: Int = 200
    
    // Today's Trades
    @FetchRequest(
        entity: OptionTrade.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \OptionTrade.date, ascending: false)],
        predicate: NSPredicate(format: "date >= %@ AND date < %@", argumentArray: [Calendar.current.startOfDay(for: Date()), Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: Date())) as Any])
    ) var optionTrades: FetchedResults<OptionTrade>

    // This Week's Trades
    @FetchRequest(
        entity: OptionTrade.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \OptionTrade.date, ascending: true)], // Assuming you want the week's trades in ascending order
        predicate: NSPredicate(format: "date >= %@ AND date <= %@", argumentArray: [Calendar.current.startOfWeek(for: Date()), Calendar.current.endOfWeek(for: Date()) as Any])
    ) var weeksTrades: FetchedResults<OptionTrade>

    

    
    var body: some View {
        ZStack {
            Image("OverviewScreen-Background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack {
            VStack {
                Text("Overview")
                    .font(.title)
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .top], 20)
                HStack {
                    //MARK: P/L Day rectangle
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 1)
                            .frame(width: 135, height: 100)
                        VStack {
                            profitLossDay()
                                .padding([.bottom], 5)
                            Text("P/L Day")
                                .foregroundStyle(Color.white)
                        }
                    }
                    .padding()
                    //MARK: # of trades
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 1)
                            .frame(width: 135, height: 100)
                        VStack {
                            numOfTrades()
                                .padding([.bottom], 5)
                                .foregroundStyle(Color.white)
                            Text("# of Trades")
                                .foregroundStyle(Color.white)
                        }
                    }
                    .padding()
                    
                    
                }
                HStack {
                    //MARK: Avg Percent
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 1)
                            .frame(width: 135, height: 100)
                        VStack {
                            avgPercent()
                                .padding([.bottom], 5)
                            Text("Avg Percent")
                                .foregroundStyle(Color.white)
                        }
                    }
                    .padding()
                    //MARK: WeeklyPT
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 1)
                            .frame(width: 135, height: 100)
                        VStack {
                            calcWeeklyPT()
                                .padding([.bottom], 5)
                            Text("Weekly PT")
                                .foregroundStyle(Color.white)
                        }
                    }
                    .padding()
                }
                .padding()
            }
                VStack {
                    var sortedWeeksTradesByProfit: [OptionTrade] {
                        weeksTrades.sorted { $0.profit > $1.profit }
                    }
                    Text("Top Performers")
                        .font(.title)
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    VStack {
                        ForEach(sortedWeeksTradesByProfit) { trade in
                            if (trade.profit > 0) {
                                TopPerformer(trade: trade)
                            }
                        }
                        
                    }
                }
            }
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
    
    func avgPercent() -> Text {
        var color: Color = .green
        var percent: Double = 0;
        
        for trade in optionTrades {
            percent += ((trade.sPrice - trade.bPrice) / trade.bPrice)
        }
        percent /= Double(optionTrades.count)
        if (percent < 0) {
            color = .red
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 0 // No decimal places

        let formattedPercent = formatter.string(from: NSNumber(value: percent)) ?? ""
        return Text("\(formattedPercent)")
            .font(.title)
            .foregroundStyle(Color(color))
    }
    
    func calcWeeklyPT() -> Text {
        var weekProfit: Int64 = 0;
        var color: Color = .green
        
        for trade in weeksTrades {
            weekProfit += (Int64((trade.sPrice - trade.bPrice) * 100) * trade.quantity)
        }
        if (weekProfit < 0) {
            color = .red
        }
        return Text("\(weekProfit)/\(weeklyPT)")
            .font(.title)
            .foregroundStyle(Color(color))
    }
}

struct OverviewView_Preview: PreviewProvider {
    static var previews: some View {
        OverviewView()
            .environment(\.managedObjectContext, DataController.shared.container.viewContext)
    }
}
