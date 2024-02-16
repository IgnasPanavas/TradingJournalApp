//
//  EditTradeView.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 2/15/24.
//

import CoreData
import SwiftUI

struct EditTradeView: View {
    var trade: OptionTrade
    @ObservedObject var viewModel: TradeViewModel
    @Environment(\.dismiss) var dismiss

    init(tradeToEdit: OptionTrade) {
        _viewModel = ObservedObject(wrappedValue: TradeViewModel(trade: tradeToEdit))
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
                    Toggle(isOn: $viewModel.callPut) {
                        Text(viewModel.callPut ? "Call" : "Put")
                    }
                    TextField("Note (Optional)", text: $viewModel.note)
                }
                
                Button("Save Trade") {
                    viewModel.updateTrade(editTrade: trade, changes: <#T##[String : Any]#>)
                    dismiss() // Dismiss the view after saving
                }
                .disabled(viewModel.ticker.isEmpty || viewModel.strikePrice.isEmpty || viewModel.buyPrice.isEmpty)
            }
            .navigationTitle("Edit Trade")
        }
    }
}
struct EditTradeView_Preview: PreviewProvider {
    static var previews: some View {
        let context = DataController.shared.container.viewContext

        // Attempt to fetch an existing OptionTrade from the context
        let fetchRequest: NSFetchRequest<OptionTrade> = OptionTrade.fetchRequest()
        
        let result = try? context.fetch(fetchRequest)
        if let existingTrade = result?.first {
            // Pass the fetched trade to the TradeSummary view
            EditTradeView(tradeToEdit: existingTrade)
        } else {
            // Fallback content in case no trades were found
            Text("No trades available")
        }
    }
}
