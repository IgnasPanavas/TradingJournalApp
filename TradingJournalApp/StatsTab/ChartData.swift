//
//  ChartData.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 2/16/24.
//

import SwiftUI
import Charts
import CoreData

class TradeChartData {
    @Published var trades: [TradeChartDataEntry]
    
    init() {
        trades = []
    }
    init(trades: [TradeChartDataEntry]) {
        self.trades = trades
    }
    func tradesChartData(forType tradeType: TradeType = .all) -> [ChartData] {
            if tradeType == .all {
                return trades.map { $0.toChartData() }
            } else {
                return trades.filter { $0.tradeType == tradeType }.map { $0.toChartData() }
            }
        }
    func totalProfitChartData(initialBalance: Double) -> [ChartData] {
        var cumulativeProfit = initialBalance
        return trades.map { entry in
            cumulativeProfit += entry.profit
            return ChartData(tradeType: entry.tradeType, date: entry.date, value: cumulativeProfit)
        }
    }
    func accountBalanceChartData(initialBalance: Double) -> [ChartData] {
        var cumulativeProfit = initialBalance
        return trades.map { entry in
            cumulativeProfit += entry.profit
            return ChartData(tradeType: entry.tradeType, date: entry.date, value: cumulativeProfit)
        }
    }
    func setTrades(tradesToAdd: [TradeChartDataEntry]) {
        trades = tradesToAdd
    }
    func tradeChartDataGroupedByType() -> [TradeType: [ChartData]] {
        var groupedData = [TradeType: [ChartData]]()
        
        for type in TradeType.allCases {
            let filteredTrades = trades.filter { $0.tradeType == type }
            groupedData[type] = filteredTrades.map { $0.toChartData() }
            print("Type: \(type), Data Count: \(groupedData[type]?.count ?? 0)")
        }
        
        print("Grouped Data: \(groupedData)")
        return groupedData
    }


}

enum TradeType: CaseIterable, Hashable, Comparable {
    case optionTrade, futureTrade, stockTrade, all

    static func < (lhs: TradeType, rhs: TradeType) -> Bool {
        // Define order based on the declaration order in the enum
        return lhs.order < rhs.order
    }

    private var order: Int {
        switch self {
        case .optionTrade:
            return 0
        case .futureTrade:
            return 1
        case .stockTrade:
            return 2
        case .all:
            return 3
        }
    }
}




struct TradeChartDataEntry: Identifiable {
    let id: UUID = UUID()
    let date: Date
    let profit: Double
    let tradeType: TradeType

    // Convert to a generic ChartData when needed
    func toChartData() -> ChartData {
        return ChartData(tradeType: tradeType, date: date, value: profit)
    }
}
struct ChartData: Identifiable {
    let tradeType: TradeType
    let id: UUID = UUID()
    let date: Date
    let value: Double // Using 'value' for generality
}

