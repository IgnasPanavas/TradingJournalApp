import SwiftUI
import CoreData

struct ClosedTradesView: View {
    @State var scrollOffset: Double = 0
    @FetchRequest(
        entity: OptionTrade.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \OptionTrade.date, ascending: false)]
    ) var optionTrades: FetchedResults<OptionTrade>
    
    @FetchRequest(
        entity: StockTrade.entity(), // Added fetch request for StockTrade
        sortDescriptors: [NSSortDescriptor(keyPath: \StockTrade.date, ascending: false)]
    ) var stockTrades: FetchedResults<StockTrade>
    
    @FetchRequest( // Added fetch request for FutureTrade
        entity: FutureTrade.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FutureTrade.date, ascending: false)]
    ) var futureTrades: FetchedResults<FutureTrade>
    
    var closedTrades: [OptionTrade] {
        optionTrades.filter { $0.closed }
    }
    
    var closedStockTrades: [StockTrade] {
        stockTrades.filter { $0.closed }
    }
    
    var closedFutureTrades: [FutureTrade] {
        futureTrades.filter { $0.closed }
    }
    
    var body: some View {
            ZStack {
                Rectangle()
                    .foregroundStyle(Color.black)
                    .ignoresSafeArea()
                VStack {
                    ScrollView {
                        GeometryReader { geometry in
                            Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: -geometry.frame(in: .named("ScrollViewCoordinateSpace")).origin.y)
                            }
                            .frame(height: 0)

                    VStack {
                        if (closedTrades.isEmpty && closedStockTrades.isEmpty && closedFutureTrades.isEmpty) {
                            Text("No closed trades")
                                .foregroundStyle(Color.white)
                        }
                        
                        ForEach(closedTrades) { trade in
                            Divider()
                                .background(.white)
                                .frame(height: 1)
                            TradeSummary(trade: trade)
                                .padding([.bottom, .top], 3)
                                .opacity(0.5)
                        }
                        
                        ForEach(closedStockTrades) { trade in
                            Divider()
                                .background(.white)
                                .frame(height: 1)
                            StockTradeSummary(stockTrade: trade)
                                .padding([.bottom, .top], 3)
                                .opacity(0.5)
                        }
                        
                        ForEach(closedFutureTrades) { trade in
                            Divider()
                                .background(.white)
                                .frame(height: 1)
                            FutureTradeSummary(trade: trade)
                                .padding([.bottom, .top], 3)
                                .opacity(0.5)
                        }
                        
                    }
                    
                    Spacer()
                }
                .frame(maxHeight: 500)
            }
            .coordinateSpace(name: "ScrollViewCoordinateSpace")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                withAnimation {
                    scrollOffset = value
                    print("\(scrollOffset)")
                }
            }
        }
    }
}

struct ClosedTradesView_Preview: PreviewProvider {
    static var previews: some View {
        ClosedTradesView().environment(\.managedObjectContext, DataController.shared.container.viewContext)
    }
}
