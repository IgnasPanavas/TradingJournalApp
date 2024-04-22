import CoreData
import SwiftUI

class StockTradeViewModel: ObservableObject {
    @Published var date: Date = Date()
    @Published var ticker: String = ""
    @Published var quantity: String = ""
    @Published var buyPrice: String = ""
    @Published var sellPrice: String = ""
    @Published var note: String = ""
    @Published var closed: Bool = false
    @Published var isLong: Bool = false // New field for isLong
    

    // Initialize for a new trade
    init() {}

    // Initialize for editing an existing trade
    init(trade: StockTrade) {
        self.ticker = trade.ticker ?? ""
        self.quantity = String(trade.quantity)
        self.buyPrice = String(trade.buyPrice)
        self.sellPrice = String(trade.sellPrice)
        self.note = trade.note ?? ""
        self.closed = trade.closed
        self.isLong = trade.isLong
        self.date = trade.date ?? Date()
        
    }
    
    func saveTrade() {
        let quant = Int64(quantity) ?? 0
        let bPrice = Double(buyPrice) ?? 0
        let sPrice = Double(sellPrice) ?? 0
        
        let newTrade = StockTrade(context: DataController.shared.container.viewContext)
        newTrade.ticker = ticker
        newTrade.quantity = quant
        newTrade.buyPrice = bPrice
        newTrade.sellPrice = sPrice
        newTrade.note = note
        newTrade.closed = closed
        newTrade.isLong = isLong
        newTrade.date = date
        
        DataController.shared.updateAccountBalance(withProfit: newTrade.calcProfit())
        DataController.shared.save()
    }
    
    func updateTrade(trade: StockTrade) {
        trade.ticker = ticker
        trade.quantity = Int64(quantity) ?? 0
        trade.buyPrice = Double(buyPrice) ?? 0
        trade.sellPrice = Double(sellPrice) ?? 0
        trade.note = note
        trade.closed = closed
        trade.isLong = isLong
        trade.date = date
        DataController.shared.updateAccountBalance(withProfit: trade.calcProfit())
        DataController.shared.save()
    }
}
