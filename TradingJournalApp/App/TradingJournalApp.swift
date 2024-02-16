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
            MainTabView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
