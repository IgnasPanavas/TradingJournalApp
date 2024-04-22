import CoreData
import SwiftUI

struct StockTradeSummary: View {
    var stockTrade: StockTrade
    @State private var translation: CGSize = .zero
    @State private var showEditTradeView = false
    @AppStorage("dateFormat") var dateFormat: String = "MM/dd/yyyy"
    @AppStorage("timeFormat") var timeFormat: String = "HH:mm"
    @AppStorage("showDecimalPlaces") var showDecimalPlaces: Bool = true
    
    let threshold: CGFloat = 150
    
    var body: some View {
           ZStack {
               Rectangle()
                   .fill() // Assuming you'll add styling

               VStack(alignment: .leading, spacing: 0) { // Eliminate spacing
                               HStack {
                                   Text(stockTrade.ticker ?? "N/A")
                                       .font(.subheadline) // Reduce font size
                                       .fontWeight(.semibold)
                                       .foregroundColor(.white)
                                   Spacer()
                                   calcProfit()
                               }

                               HStack(spacing: 10) { // Add some spacing between elements
                                   Text(formatPurchase())
                                       .font(.caption2)
                                       .lineLimit(1) // Limit to one line
                                       .foregroundColor(.white)
                                   Spacer()
                                   Text(formatDate())
                                       .font(.caption2)
                                       .foregroundColor(.white)
                               }
                           }
                           .padding(.horizontal, 8) // Reduced padding  // Apply consistent padding
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        withAnimation {
                            if (gesture.translation.width < 0) {
                                self.translation = gesture.translation
                                if abs(gesture.translation.width) > threshold {
                                    self.showEditTradeView = true
                                    self.translation = .zero
                                }
                            }
                        }
                    }
                    .onEnded { gesture in
                        withAnimation {
                            if abs(gesture.translation.width) <= threshold {
                                // Reset translation and editing state
                                self.translation = .zero
                                self.showEditTradeView = false
                            }
                        }
                    }
            )
            .offset(x: translation.width, y: 0)
            .animation(.easeInOut)
            .sheet(isPresented: $showEditTradeView) {
                //EditTradeView(stockTradeToEdit: stockTrade)
            }
        }
    }
    
    func calcProfit() -> Text {
        let profit = (stockTrade.sellPrice - stockTrade.buyPrice) * Double(stockTrade.quantity)
        let color: Color = profit > 0 ? .green : .red

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency // Use currency style for money
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = showDecimalPlaces ? 2 : 0
        formatter.maximumFractionDigits = showDecimalPlaces ? 2 : 0

        return Text(formatter.string(from: NSNumber(value: profit)) ?? "")
            .foregroundStyle(color)
    }

    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: stockTrade.date ?? Date())
    }
    
    func formatPurchase() -> String {
            let quantity = stockTrade.quantity
            // Using ternary conditional for brevity
            let shareText = quantity > 1 ? " shares" : " share"
            return "\(quantity)\(shareText) @ \(stockTrade.buyPrice)"
        }
    
}

struct StockTradeSummary_Preview: PreviewProvider {
    static var previews: some View {
        // Ensure that the DataController is initialized and the view context is set up
        let context = DataController.shared.container.viewContext

        // Attempt to fetch an existing StockTrade from the context
        let fetchRequest: NSFetchRequest = StockTrade.fetchRequest()
        
        let result = try? context.fetch(fetchRequest)
        if let existingTrade = result?.first {
            // Pass the fetched trade to the StockTradeSummary view
            StockTradeSummary(stockTrade: existingTrade)
        } else {
            // Fallback content in case no trades were found
            Text("No trades available")
        }
    }
}
