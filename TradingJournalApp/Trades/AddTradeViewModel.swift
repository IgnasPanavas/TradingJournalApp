//
//  AddTradeViewModel.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 2/11/24.
//

import SwiftUI

class AddTradeViewModel: ObservableObject {
    @Published var ticker: String = ""
    @Published var quantity: String = ""
    @Published var strikePrice: String = ""
    @Published var buyPrice: String = ""
    @Published var sellPrice: String = ""
    @Published var expDate: Date = Date()
    @Published var note: String = ""
    @Published var callPut: Bool = true // True for Call, False for Put

    // Implement a function to save the trade
    func saveTrade() {
        let quant = Int64(quantity) ?? 0
        let strikePrce = Int64(strikePrice) ?? 0
        let bPrice = Double(buyPrice) ?? 0
        let sPrice = Double(sellPrice) ?? 0
        DataController.shared.addOptionTrade(expDate: expDate, bPrice: bPrice, sPrice: sPrice, strike: strikePrce, quantity: quant, callPut: callPut, symbol: ticker, note: note, closed: false)
    }
}

