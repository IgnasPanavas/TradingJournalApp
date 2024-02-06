//
//  TradingJournalApp.swift
//  TradingJournal
//
//  Created by Ignas Panavas on 2/5/24.
//

import SwiftUI

@main
struct TradingJournalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
