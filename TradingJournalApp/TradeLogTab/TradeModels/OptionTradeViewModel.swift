//
//  AddTradeViewModel.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 2/11/24.
//

import SwiftUI

class OptionTradeViewModel: ObservableObject {
    @Published var date: Date = Date()
    @Published var ticker: String = ""
    @Published var quantity: String = ""
    @Published var strikePrice: String = ""
    @Published var buyPrice: String = ""
    @Published var sellPrice: String = ""
    @Published var expDate: Date = Date()
    @Published var note: String = ""
    @Published var callPut: Bool = true // True for Call, False for Put
    @Published var closed: Bool = false;
    @Published var error: String?
    // Initialize for a new trade
    init() {}
    
    init(error: String) {
        self.error = error
    }
    // Initialize for editing an existing trade
    init(trade: OptionTrade) {
        self.ticker = trade.ticker ?? ""
        self.quantity = String(trade.quantity)
        self.strikePrice = String(trade.strike)
        self.buyPrice = String(trade.buyPrice)
        self.sellPrice = String(trade.sellPrice)
        self.expDate = trade.expDate ?? Date()
        self.note = trade.note ?? ""
        self.callPut = trade.callPut
        self.closed = trade.closed
        self.date = trade.date ?? Date()
    }
    
    func saveTrade() {
        let quant = Int64(quantity) ?? 0
        let strikePrce = Int64(strikePrice) ?? 0
        let buyPrice = Double(buyPrice) ?? 0
        let sellPrice = Double(sellPrice) ?? 0
        
        let newTrade = OptionTrade(context: DataController.shared.container.viewContext)
        newTrade.ticker = ticker
        newTrade.quantity = quant
        newTrade.strike = strikePrce
        newTrade.buyPrice = buyPrice
        newTrade.sellPrice = sellPrice
        newTrade.expDate = expDate
        newTrade.note = note
        newTrade.callPut = callPut
        newTrade.closed = closed
        newTrade.date = date

        DataController.shared.updateAccountBalance(withProfit: newTrade.calcProfit())
        DataController.shared.save()
    }
    
    func updateTrade(trade: OptionTrade) {
        trade.ticker = ticker
        trade.quantity = Int64(quantity) ?? 0
        trade.strike = Int64(strikePrice) ?? 0
        trade.buyPrice = Double(buyPrice) ?? 0
        trade.sellPrice = Double(sellPrice) ?? 0
        trade.expDate = expDate
        trade.note = note
        trade.callPut = callPut
        trade.closed = closed
        trade.date = date
        DataController.shared.updateAccountBalance(withProfit: trade.calcProfit())
        DataController.shared.save()
    }
    
    func deleteTrade(trade: OptionTrade) {
        DataController.shared.deleteEntityById(id: trade.objectID)
    }
}
