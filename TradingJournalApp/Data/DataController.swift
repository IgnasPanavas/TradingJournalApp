import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container: NSPersistentContainer
    @Published var lastError: NSError?
    static let shared = DataController()
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    private init() {
            container = NSPersistentContainer(name: "TradeStore")
            container.loadPersistentStores { desc, error in
                if let error = error as NSError? {
                    print("Failed to load the data \(error.localizedDescription)")
                    self.lastError = error
                }
            }
        }
    
    func updateAccountBalance(withProfit profit: Double) {
        let currentBalance = UserDefaults.standard.double(forKey: "accountBalance")
        let newBalance = currentBalance + profit
        UserDefaults.standard.set(newBalance, forKey: "accountBalance")
    }
    
    func save() {
        do {
            try context.save()
            print("Data saved successfully.")
        } catch let error as NSError {
            print("Error saving the data: \(error.localizedDescription)")
            self.showError(error: error)
        }
    }
    
    func deleteAllEntities() {
        let entityNames = ["FutureTrade", "StockTrade", "OptionTrade"]
        for entityName in entityNames {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(batchDeleteRequest)
            } catch let error as NSError {
                print("Error deleting entities: \(error)")
                self.showError(error: error)
            }
        }
    }
    func deleteEntityById(id: NSManagedObjectID) { // Assuming you use NSManagedObjectID
        let object = context.object(with: id)

        context.delete(object)

        do {
             try context.save()
        } catch let error as NSError {
            self.showError(error: error)
        }
    }
    
    private func showError(error: NSError) {
            DispatchQueue.main.async {
                self.lastError = error
            }
        }
}
