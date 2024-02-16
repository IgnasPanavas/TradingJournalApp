//
//  AddTradeViewModel.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 2/11/24.
//

import SwiftUI

class TradeViewModel: ObservableObject {
    @Published var ticker: String = ""
    @Published var quantity: String = ""
    @Published var strikePrice: String = ""
    @Published var buyPrice: String = ""
    @Published var sellPrice: String = ""
    @Published var expDate: Date = Date()
    @Published var note: String = ""
    @Published var callPut: Bool = true // True for Call, False for Put

    // Initialize for a new trade
    init() {}

    // Initialize for editing an existing trade
    init(trade: OptionTrade) {
        self.ticker = trade.ticker ?? ""
        self.quantity = String(trade.quantity)
        self.strikePrice = String(trade.strike)
        self.buyPrice = String(trade.bPrice)
        self.sellPrice = String(trade.sPrice)
        self.expDate = trade.expDate ?? Date()
        self.note = trade.note ?? ""
        self.callPut = trade.callPut
    }
    
    func saveTrade() {
        let quant = Int64(quantity) ?? 0
        let strikePrce = Int64(strikePrice) ?? 0
        let bPrice = Double(buyPrice) ?? 0
        let sPrice = Double(sellPrice) ?? 0
        DataController.shared.addOptionTrade(expDate: expDate, bPrice: bPrice, sPrice: sPrice, strike: strikePrce, quantity: quant, callPut: callPut, symbol: ticker, note: note, closed: false)
    }
    func updateTrade(editTrade: OptionTrade, changes: [String: Any]) {
        // Date change
        if let newExpDate = changes["expDate"] as? Date {
            editTrade.expDate = newExpDate
        }
        
        // Double changes
        if let newBPrice = changes["bPrice"] as? Double {
            editTrade.bPrice = newBPrice
        }
        if let newSPrice = changes["sPrice"] as? Double {
            editTrade.sPrice = newSPrice
        }
        
        // Int64 changes
        if let newStrike = changes["strike"] as? Int64 {
            editTrade.strike = newStrike
        }
        if let newQuantity = changes["quantity"] as? Int64 {
            editTrade.quantity = newQuantity
        }
        
        // Boolean change
        if let newCallPut = changes["callPut"] as? Bool {
            editTrade.callPut = newCallPut
        }
        
        // String changes
        if let newSymbol = changes["ticker"] as? String {
            editTrade.ticker = newSymbol
        }
        if let newNote = changes["note"] as? String {
            editTrade.note = newNote
        }
        
        // Handling the 'closed' status, if needed
        if let newClosed = changes["closed"] as? Bool {
            editTrade.closed = newClosed
        }

        DataController.shared.save(context: DataController.shared.context)
    }

}

