//
//  DataController.swift
//  TradingJournal
//
//  Created by Ignas Panavas on 2/5/24.
//

import CoreData
import SwiftUI


class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "TradingJournal")
    
    static let shared = DataController()
    
    let context = shared.container.viewContext
    
    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("failed to load the data \(error.localizedDescription)")
            }
            
        }
        
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data saved successfully.")
        } catch {
            print("Error saving the data.")
        }
    }
    
    func addOptionTrade(expDate: Date, bPrice: Double, sPrice: Double, strike: Int64, quantity: Int64, callPut: Bool, symbol: String, note: String?) {
        
        var OptionTradeEntity = OptionTrade(context: context)
        
        OptionTradeEntity.date = Date()
        OptionTradeEntity.strike = strike
        OptionTradeEntity.expDate = expDate
        OptionTradeEntity.bPrice = bPrice
        OptionTradeEntity.sPrice = sPrice
        OptionTradeEntity.callPut = callPut
        OptionTradeEntity.note = note ?? ""
        OptionTradeEntity.quantity = quantity
        OptionTradeEntity.symbol = symbol
        
        save(context: context)
        
        
    }
    
    func removeOptionTrade(id: UUID) {
        let fetchRequest: NSFetchRequest<OptionTrade> = OptionTrade.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let entities = try context.fetch(fetchRequest)
            context.delete(entities.first!)
        } catch {
            print("Error deleting trade")
        }

        
    }
    
}
