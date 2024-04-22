//
//  TabView.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 2/13/24.
//

import SwiftUI
struct CustomTabBar: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack(spacing: 40) { // Adjust spacing as needed
            TabBarButton(imageName: "chart.bar", selectedTab: $selectedTab, tag: 0)

            TabBarButton(imageName: "person", selectedTab: $selectedTab, tag: 1)

            TabBarButton(imageName: "book", selectedTab: $selectedTab, tag: 2)
        }
        .frame(maxWidth: .infinity)
        .padding()
        
    }

    struct TabBarButton: View {
        let imageName: String
        @Binding var selectedTab: Int
        let tag: Int

        var body: some View {
            Button(action: { selectedTab = tag }) {
                Image(systemName: imageName)
                    .font(.title2) // Adjust as you like
                    .foregroundColor(selectedTab == tag ? .accentColor : .gray)
            }
        }
    }
}
struct MainTabView: View {
    @AppStorage("startingAccountBalance") var initialBalance: Double = 0
    @FetchRequest(entity: OptionTrade.entity(), sortDescriptors: []) var optionTrades: FetchedResults<OptionTrade>
    @FetchRequest(entity: FutureTrade.entity(), sortDescriptors: []) var futureTrades: FetchedResults<FutureTrade>
    @FetchRequest(entity: StockTrade.entity(), sortDescriptors: []) var stockTrades: FetchedResults<StockTrade>
    @Environment(\.managedObjectContext) var viewContext
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            StatsView(tradeChartViewModel: TradeChartViewModel(optionTrades: optionTrades, futureTrades: futureTrades, stockTrades: stockTrades, initialBalance: initialBalance))
                .tabItem {
                    Label("Stats", systemImage: "chart.bar")
                }
                .tag(0)
            
            OverviewView(isUserDataViewActive: false)
                .environment(\.managedObjectContext, viewContext)
                .tabItem {
                    Label("Overview", systemImage: "person")
                }
                .tag(1)
            
            TradeLogView()
                .environment(\.managedObjectContext, viewContext)
                .tabItem {
                    Label("Trade Log", systemImage: "book")
                }
                .tag(2)
        }
        .ignoresSafeArea()
        
       
    }
        
}

// Add this outside your view
private var tabBarImageNames = ["chart.bar", "person", "book"]



