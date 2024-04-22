//
//  TradeChartViewModel.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 4/9/24.
//

import SwiftUI

class TradeChartViewModel: ObservableObject {
    
    var initialBalance: Double
    let optionTrades: FetchedResults<OptionTrade>
    let futureTrades: FetchedResults<FutureTrade>
    let stockTrades: FetchedResults<StockTrade>
    @Published private var tradeChartData: TradeChartData = TradeChartData(trades: [])
    
    var trades: [AnyTrade] {
        let combinedTrades = optionTrades.map { AnyTrade(coreDataObject: $0 )} +
        futureTrades.map { AnyTrade(coreDataObject: $0)} +
        stockTrades.map { AnyTrade(coreDataObject: $0)}
        return combinedTrades.sorted(by: { $0.date > $1.date })
    }
    
    
    
    init(optionTrades: FetchedResults<OptionTrade>, futureTrades: FetchedResults<FutureTrade>, stockTrades: FetchedResults<StockTrade>, initialBalance: Double) {
        self.optionTrades = optionTrades
        self.futureTrades = futureTrades
        self.stockTrades = stockTrades
        self.initialBalance = initialBalance
        self.tradeChartData.setTrades(tradesToAdd: updateDailyProfitChartData())
        do {
            try updateTotalProfitChartData(startingBalance: initialBalance)
        } catch {
            // Handle the error here. For example, you might print the error description.
            print("An error occurred: \(error)")
        }
        
        printChartData()
    }
    func getTradeChartData() -> TradeChartData {
        return tradeChartData
    }
    func getInitialBalance() -> Double {
        return initialBalance
    }
    func printChartData() {
        print("trades are\(trades)")
        print("chartData is \(tradeChartData)")
    }
    func updateDailyProfitChartData() -> [TradeChartDataEntry]{
        guard !trades.isEmpty else {
            return []
        }
        let tradesPerDate = trades.reduce(into: [Date: [AnyTrade]]()) { (result, trade) in
            // Ensure date is at midnight for consistent grouping
            let dateComponent = Calendar.current.dateComponents([.day, .month, .year], from: trade.date)
            let dateAtMidnight = Calendar.current.date(from: dateComponent)!
            
            result[dateAtMidnight, default: []].append(trade)
        }
        
        let allDates = tradesPerDate.keys.sorted()
        
        var dailyProfitData: [TradeChartDataEntry] = []
        
        // Insert a zero-profit data point for the day before the earliest date if needed
        if let firstDate = allDates.first {
            let dayBeforeFirstDate = Calendar.current.date(byAdding: .day, value: -1, to: firstDate)!
            dailyProfitData.append(TradeChartDataEntry(date: dayBeforeFirstDate, profit: 0.0, tradeType: .all))
        }
        
        for date in allDates {
                let tradesForDate = tradesPerDate[date]!

                let dailyProfit = tradesForDate.reduce(0.0) { $0 + $1.calcProfit() }

                // Iterate over trades and assign the correct tradeType
                for trade in tradesForDate {
                    dailyProfitData.append(TradeChartDataEntry(date: date, profit: dailyProfit, tradeType: trade.tradeType))
                }
            }
        
       return dailyProfitData
    }

    
    func updateTotalProfitChartData(startingBalance: Double) throws {
        var totalProfit = startingBalance // Start with the initial balance
        var totalProfitData: [ChartData] = []
        for trade in trades {
            totalProfit += trade.calcProfit()
            totalProfitData.append(ChartData(tradeType: trade.tradeType, date: trade.date, value: totalProfit))
        }
    }
    
    func getTradeCount() -> Int {
        return trades.count
    }
    func filterTradesBy(predicate: AnyTradePredicate) -> [AnyTrade] {
           return trades.filter { predicate.evaluate(trade: $0) }
       }
    func calculateTodaysBalance() -> Double {
        

        // Filter trades for today - Ensure trades are sorted by date first
        let todaysTrades = trades.filter { trade in
            Calendar.current.isDate(trade.date, inSameDayAs: Date())
        }
        
        let todaysProfit = todaysTrades.reduce(0.0) { partialResult, trade in
            partialResult + trade.calcProfit()
        }
        
        return Double(initialBalance) + todaysProfit
    }
    
    func getTradePercentages() -> [(String, Double, Color)] {
        let totalTrades = optionTrades.count + futureTrades.count + stockTrades.count

        return [
            ("OptionTrade", Double(optionTrades.count) / Double(totalTrades), Color.red),
            ("FutureTrade", Double(futureTrades.count) / Double(totalTrades), Color.blue),
            ("StockTrade", Double(stockTrades.count) / Double(totalTrades), Color.green),
        ]
    }
}
