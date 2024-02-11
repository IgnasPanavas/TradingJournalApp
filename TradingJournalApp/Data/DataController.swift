
//
//  DataController.swift
//  TradingJournal
//
//  Created by Ignas Panavas on 2/5/24.
//

import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "TradeStore")
    
    static let shared = DataController()
    
    // Lazy initialization to prevent recursive call during initialization.
    lazy var context: NSManagedObjectContext = {
        self.container.viewContext
    }()
    
    private init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Failed to load the data \(error.localizedDescription)")
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
    
    func addOptionTrade(expDate: Date, bPrice: Double, sPrice: Double, strike: Int64, quantity: Int64, callPut: Bool, symbol: String, note: String?, closed: Bool) {
        
        var OptionTradeEntity = OptionTrade(context: context)
        
        OptionTradeEntity.date = Date()
        OptionTradeEntity.strike = strike
        OptionTradeEntity.expDate = expDate
        OptionTradeEntity.bPrice = bPrice
        OptionTradeEntity.sPrice = sPrice
        OptionTradeEntity.callPut = callPut
        OptionTradeEntity.note = note ?? ""
        OptionTradeEntity.quantity = quantity
        OptionTradeEntity.ticker = symbol
        OptionTradeEntity.closed = closed
        
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
    func createSeedData() {
        addOptionTrade(expDate: Date(), bPrice: 1.2, sPrice: 1.5, strike: 495, quantity: 2, callPut: true, symbol: "SPY", note: "lotto", closed: true)
        addOptionTrade(expDate: Date(), bPrice: 0.5, sPrice: 1.2, strike: 12, quantity: 1, callPut: false, symbol: "SNAP", note: "Earnings", closed: false)
    }
    func deleteAllOptionTrades() {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = OptionTrade.fetchRequest()
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            batchDeleteRequest.resultType = .resultTypeCount // Optional: Configure the result type
            
            do {
                let batchDeleteResult = try context.execute(batchDeleteRequest) as? NSBatchDeleteResult
                print("The batch delete request deleted \(batchDeleteResult?.result ?? 0) records.")
                
                // If changes are made in the persistent store, merge those changes into the context
                if let changes = batchDeleteResult?.result as? [AnyHashable: Any] {
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
                }
            } catch {
                print("Error executing batch delete request: \(error.localizedDescription)")
            }
        }
    
}



