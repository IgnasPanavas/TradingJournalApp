    import CoreData
    import SwiftUI
    import Charts
    import Combine


enum DataError: Error {
        case noTradeData(String)
        case duplicateTradeEntriesForDate(Date)
    }

struct LegendData: Identifiable {
    let id = UUID()
    let tradeType: String
    let percentage: Double
    let color: Color
}



struct StatsView: View {
    
    @EnvironmentObject var accountModel: AccountModel
    
    
    @ObservedObject var tradeChartViewModel: TradeChartViewModel
    
    @State var isShowingAlert = false
    @State private var hoveredLegendItem: String? = nil
    @Environment(\.theme) private var theme
    
    var body: some View {
        ZStack {
            theme.backgroundColor // Use theme background color
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    
                    Text("Your Stats")
                        .font(.largeTitle)
                        .foregroundColor(theme.textColor)
                        .padding()
                    
                    TabView {
                        
                        StackedBarChartView(chartData: tradeChartViewModel.getTradeChartData(), chartOptions: ChartOptions())

                        GenericChartView(chartData: tradeChartViewModel.getTradeChartData().tradesChartData(), title: "Day Profit vs. Date", chartOptions: .init())
                            .tabItem {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 30, height: 30)
                            }
                        
                        GenericChartView(chartData: tradeChartViewModel.getTradeChartData().totalProfitChartData(initialBalance: 0), title: "Total Profit vs. Date", chartOptions: .init())
                            .tabItem {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 30, height: 30)
                            }
                        
                        GenericChartView(chartData: tradeChartViewModel.getTradeChartData().totalProfitChartData(initialBalance: tradeChartViewModel.getInitialBalance()), title: "Account Balance vs. Date", chartOptions: .init())
                            .tabItem {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 30, height: 30)
                            }
                         
                    }
                    .frame(height: 350)
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    .onAppear {
                        do {
                            try tradeChartViewModel.updateTotalProfitChartData(startingBalance: tradeChartViewModel.getInitialBalance())
                        } catch {
                            // Move the alertError here
                            self.alertError {
                                throw error
                            }
                        }
                    }
                    
                    Section(header: Text("Trade Summary").foregroundColor(theme.textColor).font(.headline)) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.gray.opacity(0.7))
                            VStack(alignment: .leading) {
                                Text("Total Trades: \(tradeChartViewModel.getTradeCount())")
                                    .foregroundColor(.white)
                                Text("Winning Trades: \(tradeChartViewModel.filterTradesBy(predicate: ProfitPredicate(comparison: .greaterThan, value: 0)).count)")
                                    .foregroundColor(.green)
                                Text("Losing Trades: \(tradeChartViewModel.filterTradesBy(predicate: ProfitPredicate(comparison: .lessThan, value: 1)).count)")
                                    .foregroundColor(.red)
                            }
                            .padding()
                        }
                        .frame(width: 350, height: 100) // Adjust height as needed
                    }
                    
                    Section(header: Text("Account Balance").foregroundColor(theme.textColor).font(.headline)) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.gray.opacity(0.7))
                            VStack(alignment: .leading) {
                                Text("Balance: $\(tradeChartViewModel.calculateTodaysBalance(), specifier: "%.2f")")
                                    .foregroundColor(.white)
                            }
                            .padding()
                        }
                        .frame(width: 350, height: 80)
                    }
                    Section(header: Text("Trade Types Used").foregroundColor(theme.textColor).font(.headline)) {
                        let legendData = tradeChartViewModel.getTradePercentages().map { tradeType, percentage, color in
                            LegendData(tradeType: tradeType, percentage: percentage, color: color)
                        }

                        ZStack {
                            // Background circle
                            Circle()
                                .fill(theme.backgroundColor)
                                .frame(width: 250, height: 250)

                            // Chart
                            
                            Chart {
                                ForEach(tradeChartViewModel.getTradePercentages(), id: \.0) { tradeType, percentage, color in
                                    SectorMark(
                                        angle: .value(tradeType, percentage),
                                        innerRadius: .ratio(0.618),
                                        angularInset: 3
                                    )
                                    .accessibilityLabel(tradeType) //Keep this for other accessibility purposes
                                    .cornerRadius(4)
                                    .foregroundStyle(color)
                                }
                            }
                            .chartOverlay { chartProxy in
                                GeometryReader { geo in
                                    Rectangle()
                                        .fill(Color.clear)
                                        .contentShape(Rectangle()) // Ensure entire area is hoverable
                                        .gesture(
                                            DragGesture(minimumDistance: 0)
                                                .onChanged { value in
                                                    let location = value.location
                                                    // Use the accessibilityLabel we set
                                                    hoveredLegendItem = chartProxy.value(atX: location.x, as: String.self)
                                                    
                                                    
                                                }
                                                .onEnded { _ in
                                                    hoveredLegendItem = nil
                                                }
                                        )
                                }
                            }
                            
                            }
                            
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                            ForEach(legendData, id: \.tradeType) { item in
                                HStack {
                                    Circle()
                                        .fill(item.color)
                                        .frame(width: 15, height: 15)
                                    Text("\(item.tradeType) - \(item.percentage, specifier: "%.1f")%")
                                        .foregroundStyle(theme.textColor)
                                        .font(.caption)
                                }
                                .onTapGesture {
                                    hoveredLegendItem = item.tradeType
                                }
                                // Apply bold modifier based on hover simulation
                                .bold(item.tradeType == hoveredLegendItem ? true : false)
                            }
                        }
                        .padding()
                    }
                }
                    
                    Spacer()
                }
            
            .frame(height: 675)
            }
        
        .ignoresSafeArea()
    }

    
    

}


    
