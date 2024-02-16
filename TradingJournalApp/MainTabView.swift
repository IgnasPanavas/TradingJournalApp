//
//  TabView.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 2/13/24.
//

import SwiftUI

struct MainTabView: View {
    @Environment(\.managedObjectContext) var viewContext
    
    var body: some View {
        
        
        TabView {
            StatsView()
                .tabItem {
                    Image(systemName: "chart.bar")
                }
            OverviewView()
                .environment(\.managedObjectContext, viewContext)
                .tabItem {
                    Image(systemName: "person")
                        .foregroundStyle(Color.white)
                }
            TradeLogView()
                .environment(\.managedObjectContext, viewContext)
                .tabItem {
                    Image(systemName: "book")
                }
            
        }
    }
}

struct MainTabView_Preview: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environment(\.managedObjectContext, DataController.shared.container.viewContext)
    }
    
}
