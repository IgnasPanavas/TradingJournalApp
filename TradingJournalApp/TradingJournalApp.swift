//
//  TradingJournalAppApp.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 2/6/24.
//

import SwiftUI

@main
struct TradingJournalApp: App {
    let dataController = DataController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
