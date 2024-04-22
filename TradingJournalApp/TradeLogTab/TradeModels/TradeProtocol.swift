//
//  TradeProtocol.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 3/15/24.
//

import SwiftUI
import CoreData

protocol Trade: Identifiable {
    associatedtype IDType: Hashable // New associated type
    var id: IDType { get }
    var date: Date { get }
    var ticker: String { get }
    var quantity: Double { get }
    var buyPrice: Double { get }
    var sellPrice: Double { get }
    var note: String { get }
    var closed: Bool { get }
    
    func calcProfit() -> Double
}

struct AnyTrade: Trade {
    let coreDataObject: NSManagedObject
    
    typealias IDType = NSManagedObjectID
        
    var id: NSManagedObjectID {
        return coreDataObject.objectID
    }
    var date: Date {
        return coreDataObject.value(forKey: "date") as? Date ?? Date()
    }
    
    var ticker: String {
        return coreDataObject.value(forKey: "ticker") as? String ?? "N/A"
    }
    
    var quantity: Double {
        return coreDataObject.value(forKey: "quantity") as? Double ?? 0.0
    }
    
    var buyPrice: Double {
        return coreDataObject.value(forKey: "buyPrice") as? Double ?? 0.0
    }
    
    var sellPrice: Double {
        return coreDataObject.value(forKey: "sellPrice") as? Double ?? 0.0
    }
    
    var note: String {
        return coreDataObject.value(forKey: "note") as? String ?? ""
    }
    
    var closed: Bool {
        return coreDataObject.value(forKey: "closed") as? Bool ?? false
    }
    var tradeType: TradeType {
        if coreDataObject.isKind(of: OptionTrade.self) {
            return .optionTrade
        } else if coreDataObject.isKind(of: FutureTrade.self) {
            return .futureTrade
        } else if coreDataObject.isKind(of: StockTrade.self) {
            return .stockTrade
        } else {
            return .all
        }
    }
    
    func calcProfit() -> Double {
        // Determine the entity type
        if let optionTrade = coreDataObject as? OptionTrade {
            return (optionTrade.sellPrice - optionTrade.buyPrice) * Double(optionTrade.quantity) * 100
        } else if let stockTrade = coreDataObject as? StockTrade {
            return (stockTrade.sellPrice - stockTrade.buyPrice) * Double(stockTrade.quantity)
        } else if let futureTrade = coreDataObject as? FutureTrade {
            return (futureTrade.sellPrice - futureTrade.buyPrice) * Double(futureTrade.quantity) * futureTrade.tickSize
        } else {
            // Handle the case where the entity type is not recognized or supported
            // For example, you might return 0 or throw an error.
            return 0.0
        }
    }
}
