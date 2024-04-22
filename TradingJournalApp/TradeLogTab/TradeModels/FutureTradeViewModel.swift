import SwiftUI

class FutureTradeViewModel: ObservableObject {
    @Published var date: Date = Date()
    @Published var ticker: String = ""
    @Published var quantity: String = ""
    @Published var tickSize: String = ""
    @Published var buyPrice: String = ""
    @Published var sellPrice: String = ""
    @Published var note: String = ""
    @Published var isLong: Bool = true // True for Long, False for Short
    @Published var closed: Bool = false
    
    
   

    // Initialize for a new trade
    init() {}

    // Initialize for editing an existing trade
    init(trade: FutureTrade) {
        self.ticker = trade.ticker ?? ""
        self.quantity = String(trade.quantity)
        self.tickSize = String(trade.tickSize)
        self.buyPrice = String(trade.buyPrice)
        self.sellPrice = String(trade.sellPrice)
        self.note = trade.note ?? ""
        self.isLong = trade.isLong
        self.closed = trade.closed
        self.date = trade.date ?? Date()
        
    }
    
    func saveTrade() {
        let newTrade = FutureTrade(context: DataController.shared.container.viewContext)
        newTrade.ticker = ticker
        newTrade.quantity = Int64(quantity) ?? 0
        newTrade.tickSize = Double(tickSize) ?? 0
        newTrade.buyPrice = Double(buyPrice) ?? 0
        newTrade.sellPrice = Double(sellPrice) ?? 0
        newTrade.note = note
        newTrade.isLong = isLong
        newTrade.closed = closed
        newTrade.date = date
        DataController.shared.updateAccountBalance(withProfit: newTrade.calcProfit())
        DataController.shared.save()
    }
    
    func updateTrade(trade: FutureTrade) {
        trade.ticker = ticker
        trade.quantity = Int64(quantity) ?? 0
        trade.tickSize = Double(tickSize) ?? 0
        trade.buyPrice = Double(buyPrice) ?? 0
        trade.sellPrice = Double(sellPrice) ?? 0
        trade.note = note
        trade.isLong = isLong
        trade.closed = closed
        trade.date = date
        DataController.shared.updateAccountBalance(withProfit: trade.calcProfit())
        DataController.shared.save()
    }
}
