//
//  OptionTrade.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 2/15/24.
//

import SwiftUI
import CoreData

extension OptionTrade {
    
    func calcProfit() -> Double {
        return (sellPrice - buyPrice) * Double(quantity) * 100
    }
}
extension StockTrade {
    func calcProfit() -> Double {
        return (sellPrice - buyPrice) * Double(quantity) // Assuming 'quantity' exists on StockTrade
    }
}
extension FutureTrade {
    
    func calcProfit() -> Double {
        // Futures profit calculation with 4 ticks in a point
        return Double(quantity) * 4 * tickSize // Multiply by quantity and tick size
    }
}
 

