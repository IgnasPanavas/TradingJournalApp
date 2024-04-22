import SwiftUI
import CoreData

struct OpenTradesView: View {
    @State var scrollOffset: Double = 0
    @FetchRequest(
        entity: OptionTrade.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \OptionTrade.date, ascending: false)]
    ) var optionTrades: FetchedResults<OptionTrade>
    
    @FetchRequest(
        entity: FutureTrade.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FutureTrade.date, ascending: false)]
    ) var futureTrades: FetchedResults<FutureTrade>
    
    @FetchRequest(
        entity: StockTrade.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \StockTrade.date, ascending: false)]
    ) var stockTrades: FetchedResults<StockTrade>
    
    var openTrades: [OptionTrade] {
        optionTrades.filter { !$0.closed }
    }
    
    var openFutureTrades: [FutureTrade] {
        futureTrades.filter { !$0.closed }
    }
    
    var openStockTrades: [StockTrade] {
        stockTrades.filter { !$0.closed }
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
                        if (openTrades.isEmpty && openFutureTrades.isEmpty && openStockTrades.isEmpty) {
                            Text("No open trades")
                                .foregroundStyle(Color.white)
                        }
                        
                        ForEach(openTrades) { trade in
                            Divider()
                                .background(.white)
                                .frame(height: 1)
                            TradeSummary(trade: trade)
                                .padding([.bottom, .top], 3)
                                
                        }
                        
                        ForEach(openFutureTrades) { trade in
                            Divider()
                                .background(.white)
                                .frame(height: 1)
                            FutureTradeSummary(trade: trade)
                                .padding([.bottom, .top], 3)
                                
                        }
                        
                        ForEach(openStockTrades) { trade in
                            Divider()
                                .background(.white)
                                .frame(height: 1)
                                StockTradeSummary(stockTrade: trade)
                                .padding([.bottom, .top], 3)
                                
                        }
                        
                    }
                    
                    
                }
                                .padding([.bottom], 50)
                            }
            .coordinateSpace(name: "ScrollViewCoordinateSpace") 
                            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                                withAnimation {
                                    scrollOffset = value
                                    print("\(scrollOffset)")
                                }
                            }
                            .frame(maxHeight: 500)
                        }
                    }
                }
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue() // Accumulate offsets
    }
}


