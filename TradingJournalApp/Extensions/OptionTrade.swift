//
//  OptionTrade.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 2/15/24.
//

import SwiftUI
import CoreData

extension OptionTrade {
    var profit: Double {
        return sPrice - bPrice
    }
}

