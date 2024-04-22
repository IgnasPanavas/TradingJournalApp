//
//  OverviewView.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 2/13/24.
//

import CoreData
import SwiftUI


struct OverviewView: View {
    @Environment(\.theme) var theme
    @AppStorage("accountBalance") var accountBalance: Double = 0.0
    @State private var scrollOffset: CGFloat = 0
    @State private var showingSmallerAddButton = false
    @State var isDisclosureShowing: Bool = false
    @AppStorage("weeklyProfitTarget") var weeklyPT: Int = 200
    @EnvironmentObject var userData: UserViewModel
    @State var isUserDataViewActive: Bool
    @State var showingAddTrade = false
    @State private var isUnlocked = false
    var sortedWeeksTradesByProfit: [AnyTrade] {
        let allTrades: [AnyTrade] = weekOptionTrades.map { AnyTrade(coreDataObject: $0 as NSManagedObject) }
            + weekStockTrades.map { AnyTrade(coreDataObject: $0 as NSManagedObject) }
            + weekFutureTrades.map { AnyTrade(coreDataObject: $0 as NSManagedObject) }
        
        // Sort the data only once outside of the VStack
        return allTrades.sorted { $0.calcProfit() > $1.calcProfit() }
    }
    // Today's Trades
    @FetchRequest(
            entity: OptionTrade.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \OptionTrade.date, ascending: false)],
            predicate: NSPredicate(format: "date >= %@ AND date < %@", argumentArray: [Calendar.current.startOfDay(for: Date()), Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: Date())) as Any])
        ) var dailyOptionTrades: FetchedResults<OptionTrade>

    @FetchRequest(
            entity: StockTrade.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \StockTrade.date, ascending: false)],
            predicate: NSPredicate(format: "date >= %@ AND date < %@", argumentArray: [Calendar.current.startOfDay(for: Date()), Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: Date())) as Any])
        ) var dailyStockTradeEntities: FetchedResults<StockTrade>

    @FetchRequest(
            entity: FutureTrade.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \FutureTrade.date, ascending: false)],
            predicate: NSPredicate(format: "date >= %@ AND date < %@", argumentArray: [Calendar.current.startOfDay(for: Date()), Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: Date())) as Any])
        ) var dailyFutureTradeEntities: FetchedResults<FutureTrade>
    
    @FetchRequest(
            entity: OptionTrade.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \OptionTrade.date, ascending: false)],
            predicate: NSPredicate(format: "date >= %@ AND date <= %@", argumentArray: [Calendar.current.startOfWeek(for: Date()), Calendar.current.endOfWeek(for: Date()) as Any])
        ) var weekOptionTrades: FetchedResults<OptionTrade>
    
    @FetchRequest(
            entity: StockTrade.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \StockTrade.date, ascending: false)],
            predicate: NSPredicate(format: "date >= %@ AND date <= %@", argumentArray: [Calendar.current.startOfWeek(for: Date()), Calendar.current.endOfWeek(for: Date()) as Any])
        ) var weekStockTrades: FetchedResults<StockTrade>

    // This Week's Future Trades
    @FetchRequest(
            entity: FutureTrade.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \FutureTrade.date, ascending: false)],
            predicate: NSPredicate(format: "date >= %@ AND date <= %@", argumentArray: [Calendar.current.startOfWeek(for: Date()), Calendar.current.endOfWeek(for: Date()) as Any])
        ) var weekFutureTrades: FetchedResults<FutureTrade>
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .foregroundStyle(theme.backgroundColor)
                    .edgesIgnoringSafeArea(.all)
                    ScrollView {
                        GeometryReader { geo in
                            Color.clear.preference(key: ViewOffsetKey.self, value: -geo.frame(in: .named("scroll")).origin.y)
                        }
                        .frame(height: 0)
                        
                        VStack {
                            
                            VStack {
                                UserDataHeaderView(isUserDataViewActive: $isUserDataViewActive)
                                    .sheet(isPresented: $isUserDataViewActive) {
                                        SettingsView()
                                            
                                    }
                                    .frame(width: geometry.size.width - 50)
                                VStack(alignment: .center, spacing: 5) {
                                                        Text("$\(accountBalance, specifier: "%.2f")")
                                                            .font(.system(size: 36))
                                                            .foregroundColor(theme.textColor)
                                                        Text("Account Balance")
                                                            .font(.footnote)
                                                            .foregroundColor(theme.textColor.opacity(0.7))
                                                    }
                                                    .padding([.top, .bottom], 50)
                                let idealCardWidth: CGFloat = geometry.size.width / 2 - 50
                                HStack(spacing: 20) { // Added spacing between cards
                                    MetricCard(title: "P/L Day", value: profitLossDay(), width: idealCardWidth)
                                        
                                    MetricCard(title: "# of Trades", value: numOfTrades(), width: idealCardWidth)
                                        
                                }
                                .frame(width: geometry.size.width)
                                .frame(alignment: .center)
                                .padding()

                                                    // Modified HStack for dynamic widths
                                                    HStack(spacing: 20) {
                                                        MetricCard(title: "Avg Percent", value: avgPercent(), width: idealCardWidth)
                                                            //.frame(width: geometry.size.width / 2 - 30)
                                                        MetricCard(title: "Weekly PT", value: calcWeeklyPT(), width: idealCardWidth)
                                                            //.frame(width: geometry.size.width / 2 - 30)
                                                    }
                                                    .frame(maxWidth: geometry.size.width)
                                                    .frame(alignment: .center)
                                                    
                                
                            }
                            Spacer()
                            VStack {
                                
                                Text("Top Performers")
                                    .font(.title)
                                    .foregroundColor(theme.textColor)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding()
                                
                                if sortedWeeksTradesByProfit.filter({ $0.calcProfit() > 0 }).isEmpty {
                                    Spacer()
                                        .frame(height: 250)
                                    VStack {
                                        DefaultMessageView(message: "No top performers found. Make a positive trade to see them!", iconName: "chart.bar.xaxis")
                                        
                                        Text("Please make a positive trade to see the top performers.")
                                            .foregroundStyle(theme.textColor)
                                            .frame(maxWidth: .infinity, alignment: .center)
                                            .font(.caption)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .center)
                                } else {
                                    VStack {
                                        ForEach(sortedWeeksTradesByProfit.prefix(3)) { trade in
                                            if trade.calcProfit() > 0 {
                                                TopPerformer(trade: trade, width: geometry.size.width - 80)
                                            }
                                        }
                                    }
                                    .frame(width: geometry.size.width)
                                }
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            Spacer()
                                .frame(height: 250)
                            HStack (spacing: 0) {
                                Text("View our full disclosures ")
                                    .foregroundStyle(theme.textColor)
                                Button("here") {
                                    isDisclosureShowing.toggle()
                                }
                                .foregroundStyle(theme.textColor)
                                .underline()
                                
                                
                            }
                            .fullScreenCover(isPresented: $isDisclosureShowing) {
                                    DisclosureView(isDisclosureShowing: $isDisclosureShowing)
                                        .edgesIgnoringSafeArea(.all)
                                        .background(theme.backgroundColor.opacity(0.25))

                                    
                                }
                            .frame(maxWidth: .infinity)
                            .frame(alignment: .leading)
                            Spacer()
                        }
                        .frame(width: geometry.size.width)
                        .onChange(of: scrollOffset) {
                            withAnimation {
                                if scrollOffset > 20 {
                                    showingSmallerAddButton = true
                                } else {
                                    showingSmallerAddButton = false
                                }
                            }
                        
                        }
                    }
                    .coordinateSpace(name: "scroll")
                    .onPreferenceChange(ViewOffsetKey.self) { value in
                        withAnimation {
                            scrollOffset = value
                            
                        }
                    }
                    
                    .frame(height: geometry.size.height * 0.95)
                
                FloatingAddButton(showingAddTrade: $showingAddTrade)
                    .opacity(scrollOffset > 30 ? 1 : 0) // Show when scrolled down
                    .animation(.default, value: scrollOffset)
                    .position(x: geometry.size.width - 50, y: geometry.size.height - min(scrollOffset - 100, 50))
                
                
                AddTradeButton(showingAddTrade: $showingAddTrade)
                    .offset(y: scrollOffset > 0 ? scrollOffset : 0) // Hide when scrolling down
                    .opacity(scrollOffset < 20 ? 1 : 0) // Fade out animation
                    .position(CGPoint(x: 195, y: 650.0))
                
            }
            
            .sheet(isPresented: $showingAddTrade) {

                    AddOptionTrade(viewModel: OptionTradeViewModel())
                        .presentationCornerRadius(36)
                        .preferredColorScheme(.light) 
                        
            }
        }
    }
    
    func profitLossDay() -> Text {
        var toReturn: String = ""
        var profitLoss: Double = 0;
        var color: Color = .green
        for trade in dailyOptionTrades {
                profitLoss += (trade.sellPrice - trade.buyPrice) * 100 * Double(trade.quantity)
            }
        toReturn = String(format: "%@%.2f", profitLoss >= 0 ? "+" : "", profitLoss)
        if (profitLoss < 0) {
            color = .red
        }
        return Text(toReturn)
            .foregroundStyle(Color(color))
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
        
    }
    
    func numOfTrades() -> Text {
        let numTrades: Int = dailyOptionTrades.count
        return Text("\(numTrades)")
            .font(.title)
            .foregroundStyle(theme.textColor)
    }
    
    func avgPercent() -> Text {
        var color: Color = .green
        var percent: Double = 0;
        
        for trade in dailyOptionTrades {
            percent += ((trade.sellPrice - trade.buyPrice) / trade.buyPrice)
        }
        percent /= Double(dailyOptionTrades.count)
        if (percent < 0) {
            color = .red
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 0 // No decimal places

        let formattedPercent = formatter.string(from: NSNumber(value: percent)) ?? ""
        return Text("\(formattedPercent)")
            .font(.title)
            .foregroundStyle(Color(color))
    }
    
    func calcWeeklyPT() -> Text {
        var weekProfit: Int64 = 0;
        var color: Color = .green
        
        for trade in weekOptionTrades {
            weekProfit += (Int64((trade.sellPrice - trade.buyPrice) * 100) * trade.quantity)
        }
        if (weekProfit < 0) {
            color = .red
        }
        return Text("\(weekProfit)/\(weeklyPT)")
            .font(.title)
            .foregroundStyle(Color(color))
    }
    }

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct FloatingAddButton: View {
    @Binding var showingAddTrade: Bool

    var body: some View {
        Button(action: {
            showingAddTrade.toggle()
        }) {
            Image(systemName: "plus.circle.fill")
                .font(.largeTitle)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.blue) // Neumorphism-ish style
        .clipShape(Circle())
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 3, y: 3)
        .shadow(color: Color.white.opacity(0.7), radius: 5, x: -3, y: -3)
    }
}

struct AddTradeButton: View {
    @Environment(\.theme) var theme
    @Binding var showingAddTrade: Bool
    
    var body: some View {
        Button(action: {
            showingAddTrade.toggle()
        }) {
            Text("Add a Trade")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(theme.backgroundColor)
                .frame(width: 300)
                .padding()
                .background(theme.textColor)
                .cornerRadius(20)
        }
    }
}

struct MetricCard: View {
    @Environment(\.theme) var theme
    let title: String
    let value: Text
    let width: CGFloat
    
    
    var body: some View {
        VStack {
            value
                .font(.system(size: 16, weight: .light, design: .default))
                .foregroundColor(theme.textColor)
                .minimumScaleFactor(0.5)
                .dynamicTypeSize(...DynamicTypeSize.small)  // Adjust the range as necessary
            Text(title)
                .font(.caption)
                .foregroundColor(theme.textColor.opacity(0.7))
                .minimumScaleFactor(0.5)
                .dynamicTypeSize(...DynamicTypeSize.small)
        }
        .frame(width: width)
        .padding()
        .background(theme.backgroundColor)
        .cornerRadius(10)
        .shadow(radius: 2)
        

    }
}
struct DefaultMessageView: View {
    var message: String
    var iconName: String? = nil
    @Environment(\.theme) var theme // Inject the theme

    var body: some View {
        VStack {
            if let iconName = iconName {
                Image(systemName: iconName)
                    .font(.largeTitle)
                    .foregroundColor(theme.textColor) // Use theme color
            }
            Text(message)
                .foregroundStyle(theme.textColor) // Use theme color
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}
