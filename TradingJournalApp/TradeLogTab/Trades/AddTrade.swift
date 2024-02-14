//
//  AddTrade.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 2/11/24.
//

import CoreData
import SwiftUI

struct AddTrade: View {
    @ObservedObject var viewModel = AddTradeViewModel()
    @Environment(\.dismiss) var dismiss

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
                    viewModel.saveTrade()
                    dismiss() // Dismiss the view after saving
                }
                .disabled(viewModel.ticker.isEmpty || viewModel.strikePrice.isEmpty || viewModel.buyPrice.isEmpty)
            }
            .navigationTitle("Add Trade")
        }
    }
}


struct AddTrade_Preview: PreviewProvider {
    static var previews: some View {
        AddTrade()
    }
}
