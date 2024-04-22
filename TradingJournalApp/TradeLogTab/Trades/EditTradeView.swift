//
//  EditTradeView.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 2/15/24.
//

import CoreData
import SwiftUI


struct EditOptionTradeView: View {
    var trade: OptionTrade
    @ObservedObject var viewModel: OptionTradeViewModel
    @Environment(\.dismiss) var dismiss

    init(tradeToEdit: OptionTrade) {
        _viewModel = ObservedObject(wrappedValue: OptionTradeViewModel(trade: tradeToEdit))
        trade = tradeToEdit
    }
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Trade Details")) {
                    TextField("Ticker", text: $viewModel.ticker)
                    TextField("Strike Price", text: $viewModel.strikePrice)
                        .keyboardType(.decimalPad)
                    TextField("Quantity", text: $viewModel.quantity)
                        .keyboardType(.numberPad)
                    TextField("Buy Price", text: $viewModel.buyPrice)
                        .keyboardType(.decimalPad)
                    TextField("Sell Price (Optional)", text: $viewModel.sellPrice)
                        .keyboardType(.decimalPad)
                    DatePicker("Expiration Date", selection: $viewModel.expDate, displayedComponents: .date)
                    
                    HStack {
                        Text("Side")
                        Spacer()
                        Image(systemName: "arrow.up")
                            .foregroundStyle(self.viewModel.callPut ? Color.green : Color.black)
                            .onTapGesture {
                                self.viewModel.callPut = true
                                
                            }
                        
                        Image(systemName: "arrow.down")
                            .foregroundStyle(self.viewModel.callPut ? Color.black : Color.red)
                            .onTapGesture {
                                self.viewModel.callPut = false // Set to "Put" when down arrow is tapped
                            }
                    }
                    
                    TextField("Note (Optional)", text: $viewModel.note)
                    Toggle(isOn: $viewModel.closed) {
                        Text(viewModel.closed ? "Closed" : "Open")
                    }
                }

                Button("Save Trade") {
                    viewModel.updateTrade(trade: trade)
                    dismiss() // Dismiss the view after saving
                }
                .disabled(viewModel.ticker.isEmpty || viewModel.strikePrice.isEmpty || viewModel.buyPrice.isEmpty)
                Button("Delete Trade") {
                    viewModel.deleteTrade(trade:trade)
                    dismiss()
                }
            }
            .navigationTitle("Edit Trade")
        }
    }
}
struct EditStockTradeView: View {
    var trade: StockTrade
    @ObservedObject var viewModel: StockTradeViewModel
    @Environment(\.dismiss) var dismiss

    init(tradeToEdit: StockTrade) {
        _viewModel = ObservedObject(wrappedValue: StockTradeViewModel(trade: tradeToEdit))
        trade = tradeToEdit
    }
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Trade Details")) {
                    TextField("Ticker", text: $viewModel.ticker)
                    TextField("Quantity", text: $viewModel.quantity)
                        .keyboardType(.numberPad)
                    TextField("Buy Price", text: $viewModel.buyPrice)
                        .keyboardType(.decimalPad)
                    TextField("Sell Price (Optional)", text: $viewModel.sellPrice)
                        .keyboardType(.decimalPad)
                    DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
                    
                    HStack {
                        Text("Direction")
                        Spacer()
                        Toggle(isOn: $viewModel.isLong) {
                            Text(viewModel.isLong ? "Long" : "Short")
                        }
                    }
                    
                    TextField("Note (Optional)", text: $viewModel.note)
                    Toggle(isOn: $viewModel.closed) {
                        Text(viewModel.closed ? "Closed" : "Open")
                    }
                }

                Button("Save Trade") {
                    viewModel.updateTrade(trade: trade)
                    dismiss() // Dismiss the view after saving
                }
                .disabled(viewModel.ticker.isEmpty || viewModel.buyPrice.isEmpty)
            }
            .navigationTitle("Edit Trade")
        }
    }
}
struct EditFutureTradeView: View {
    @StateObject var viewModel: FutureTradeViewModel
    @Environment(\.dismiss) var dismiss
    var trade: FutureTrade
    
    init(tradeToEdit: FutureTrade) {
        _viewModel = StateObject(wrappedValue: FutureTradeViewModel(trade: tradeToEdit))
        trade = tradeToEdit
    }
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Trade Details")) {
                    TextField("Ticker", text: $viewModel.ticker)
                    TextField("Quantity", text: $viewModel.quantity)
                        .keyboardType(.numberPad)
                    TextField("Tick Size", text: $viewModel.tickSize)
                        .keyboardType(.decimalPad)
                    TextField("Buy Price", text: $viewModel.buyPrice)
                        .keyboardType(.decimalPad)
                    TextField("Sell Price (Optional)", text: $viewModel.sellPrice)
                        .keyboardType(.decimalPad)
                    DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
                    
                    HStack {
                        Text("Direction")
                        Spacer()
                        Toggle(isOn: $viewModel.isLong) {
                            Text(viewModel.isLong ? "Long" : "Short")
                        }
                    }
                    
                    TextField("Note (Optional)", text: $viewModel.note)
                    Toggle(isOn: $viewModel.closed) {
                        Text(viewModel.closed ? "Closed" : "Open")
                    }
                }

                Button("Save Trade") {
                    viewModel.updateTrade(trade: trade)
                    dismiss() // Dismiss the view after saving
                }
                .disabled(viewModel.ticker.isEmpty || viewModel.buyPrice.isEmpty || viewModel.tickSize.isEmpty)
            }
            .navigationTitle("Edit Future Trade")
        }
    }
}


struct EditTradeView_Preview: PreviewProvider {
    static var previews: some View {
        let context = DataController.shared.container.viewContext

        // Attempt to fetch an existing OptionTrade from the context
        let fetchRequest: NSFetchRequest<FutureTrade> = FutureTrade.fetchRequest()
        
        let result = try? context.fetch(fetchRequest)
        if let existingTrade = result?.first {
            // Pass the fetched trade to the TradeSummary view
            EditFutureTradeView(tradeToEdit: existingTrade)
        } else {
            // Fallback content in case no trades were found
            Text("No trades available")
        }
    }
}
