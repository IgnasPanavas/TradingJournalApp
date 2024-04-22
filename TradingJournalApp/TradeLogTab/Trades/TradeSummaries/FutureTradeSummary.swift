import CoreData
import SwiftUI

struct FutureTradeSummary: View {
    var trade: FutureTrade
    @State private var translation: CGSize = .zero
    @State private var showEditTradeView = false
    @AppStorage("dateFormat") var dateFormat: String = "MM/dd/yyyy"
    @AppStorage("timeFormat") var timeFormat: String = "HH:mm"
    @AppStorage("showDecimalPlaces") var showDecimalPlaces: Bool = true
   
    
    let threshold: CGFloat = 150
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill()
            VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                Text(trade.ticker ?? "N/A")
                                    .font(.subheadline) // Match StockTradeSummary
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                calcProfit()
                            }

                            HStack(spacing: 10) {
                                Text(formatPurchase())
                                    .font(.caption2) // Match StockTradeSummary
                                    .lineLimit(1)
                                    .foregroundColor(.white)
                                Spacer()
                                Text(formatDate())
                                    .font(.caption2) // Match StockTradeSummary
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal, 8)
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
                EditFutureTradeView(tradeToEdit: trade)
            }
        }
    }
    
    func calcProfit() -> Text {
        // Calculate the profit in points
        let profitInPoints = (trade.sellPrice - trade.buyPrice) / 4
        
        // Convert profit in points to dollars (assuming each point is worth $25)
        let profitInDollars = profitInPoints * 25
        
        let color: Color = profitInDollars > 0 ? .green : .red
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency // Use currency style for money
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return Text(formatter.string(from: NSNumber(value: profitInDollars)) ?? "")
            .foregroundStyle(color)
    }
    
    func formatPurchase() -> String {
        let quantity: Int64 = trade.quantity
        var toReturn: String = "\(quantity)"

        if quantity > 1 {
            toReturn.append(" contracts")
        } else {
            toReturn.append(" contract")
        }
        toReturn.append(" @ \(trade.buyPrice)")
        return toReturn
    }
    
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat // Use the shared dateFormat
        return dateFormatter.string(from: trade.date ?? Date())
    }
}
struct FutureTradeSummary_Preview: PreviewProvider {
    static var previews: some View {
        // Ensure that the DataController is initialized and the view context is set up
        let context = DataController.shared.container.viewContext

        // Attempt to fetch an existing FutureTrade from the context
        let fetchRequest: NSFetchRequest = FutureTrade.fetchRequest()
        
        let result = try? context.fetch(fetchRequest)
        if let existingTrade = result?.first {
            // Pass the fetched trade to the FutureTradeSummary view
            FutureTradeSummary(trade: existingTrade)
        } else {
            // Fallback content in case no trades were found
            Text("No trades available")
        }
    }
}
