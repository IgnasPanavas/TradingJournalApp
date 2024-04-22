//
//  ProfitPredicate.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 4/8/24.
//

import SwiftUI

protocol AnyTradePredicate {
    func evaluate(trade: AnyTrade) -> Bool
}

struct ProfitPredicate: AnyTradePredicate {
    let comparison: ComparisonOperator
    let value: Double

    enum ComparisonOperator { case greaterThan, lessThan, equalTo }

    func evaluate(trade: AnyTrade) -> Bool {
        switch comparison {
        case .greaterThan: return trade.calcProfit() > value
        case .lessThan: return trade.calcProfit() < value
        case .equalTo: return trade.calcProfit() == value
        }
    }
}
