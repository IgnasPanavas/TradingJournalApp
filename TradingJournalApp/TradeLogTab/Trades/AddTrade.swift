//
//  AddTrade.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 2/11/24.
//

import CoreData
import SwiftUI

struct AddTrade: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView {
            AddOptionTrade(viewModel: OptionTradeViewModel())
                .tabItem {
                    Image(systemName: "triangleshape")
                        .foregroundStyle(.secondary)
                    Text("Option Trade")
                }
            AddFutureTrade(viewModel: FutureTradeViewModel())
                .tabItem {
                    Image(systemName: "calendar.badge.clock")
                    Text("Future Trade")
                }
            AddStockTrade(viewModel: StockTradeViewModel())
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Stock Trade")
                }
        }
    }
}


struct AddOptionTrade: View {
    @ObservedObject var viewModel: OptionTradeViewModel
    @Environment(\.dismiss) var dismiss
    @State var outlineColor: Color = .green
    @State private var currentStep = 0 // Start at step 0

    var body: some View {
        ZStack {
            TabView (selection: $currentStep) {
                            StepOneView(viewModel: viewModel, outlineColor: $outlineColor, currentStep: $currentStep)
                                .tag(0)
                            
                            StepTwoView(viewModel: viewModel, currentStep: $currentStep)
                                .tag(1)

                            StepThreeView(viewModel: viewModel, currentStep: $currentStep)
                                .tag(2) // New step
                        }
                .zIndex(1)
                .tabViewStyle(.page) // Makes tabs swipeable
            LinearGradient(gradient: Gradient(colors: [.white, outlineColor]), startPoint: .top, endPoint: .bottom)
                .opacity(1)
                .ignoresSafeArea()
                .zIndex(0)
        }
    }
}

struct StepOneView: View {
    @ObservedObject var viewModel: OptionTradeViewModel
    @Binding var outlineColor: Color
    @Binding var currentStep: Int

    var body: some View {
        VStack (spacing: 30){
            
            CustomButton(title: "Call", iconName: "arrow.up", isSelected: viewModel.callPut, outlineColor: $outlineColor) {
                    viewModel.callPut = true
                withAnimation {
                    updateOutlineAndStep()
                }
                }

            CustomButton(title: "Put", iconName: "arrow.down", isSelected: !viewModel.callPut, outlineColor: $outlineColor) {
                    viewModel.callPut = false
                    withAnimation {
                        updateOutlineAndStep()
                    }
                }
        }
        .padding()
        
        
    }

    private func updateOutlineAndStep() {
        outlineColor = viewModel.callPut ? .green : .red
            currentStep = 1
    }
    struct CustomButton: View {
        let title: String
        let iconName: String
        var isSelected: Bool
        @Binding var outlineColor: Color
        let action: () -> Void

        var body: some View {
            Button(action: action) {
                Text(title)
                    .font(.title2)
                    .padding()
                Image(systemName: iconName)
                    
            }
            
            .frame(width: 350, height: 100)
            .background(Color(.systemBackground).opacity(0.5))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? .black : .clear, lineWidth: 2)
            )
            
        }
    }
}


struct StepTwoView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: OptionTradeViewModel
    @Binding var currentStep: Int

    
    var body: some View {
        VStack(spacing: 40) {
            
            tradeFieldsForm
            .onSubmit {
                withAnimation {
                    currentStep += 1
                }
            }
            
            
        }
        .foregroundStyle(Color.white)
        .frame(height: 500)
    }
    var tradeFieldsForm: some View {
        return ZStack {
            
            VStack {
                Section {
                    TextField("Strike Price", text: $viewModel.strikePrice)
                        .keyboardType(.decimalPad)
                    DatePicker("Expiration Date", selection: $viewModel.expDate, displayedComponents: .date)
                }
                .padding(9)
                .background(Color(.systemBackground).opacity(0.2))
                    .cornerRadius(8)
                    
                    .foregroundStyle(Color.black)
                .padding(5)
                .frame(width: 350)
            }
            .padding()
            .overlay( // Overlay with the border
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
            
        }
    }
}
struct StepThreeView: View {
    @ObservedObject var viewModel: OptionTradeViewModel
    @Binding var currentStep: Int
    @Environment(\.dismiss) var dismiss

    var isFormEmpty: Bool {
        viewModel.ticker.isEmpty || viewModel.quantity.isEmpty || viewModel.buyPrice.isEmpty
    }

    var body: some View {
        VStack(spacing: 40) {
            tradeFieldsForm

            Button("Save Trade") {
                viewModel.saveTrade()
                dismiss() // Assuming 'dismiss' works in your context
            }
            .frame(width: 300)
            .padding()
            .background(Color.gray)
            .cornerRadius(10)
            .disabled(isFormEmpty)
        }
        .foregroundStyle(Color.white)
        .frame(height: 500)
       
    }

    var tradeFieldsForm: some View {
        ZStack {
            VStack {
                Section {
                    TextField("Ticker", text: $viewModel.ticker)
                    TextField("Quantity", text: $viewModel.quantity)
                        .keyboardType(.numberPad)
                    TextField("Buy Price", text: $viewModel.buyPrice)
                        .keyboardType(.decimalPad)
                    TextField("Sell Price (Optional)", text: $viewModel.sellPrice)
                        .keyboardType(.decimalPad)
                    TextField("Note (Optional)", text: $viewModel.note)
                }
                .padding(9)
                .background(Color(.systemBackground).opacity(0.2))
                .cornerRadius(8)
                .foregroundStyle(Color.black)
                .padding(5)
                .frame(width: 350)
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
    }
}

struct AddOptionTrade_Previews: PreviewProvider {
    static var previews: some View {
        // Instantiate the view with a mock ViewModel
        AddOptionTrade(viewModel: OptionTradeViewModel())
            
            .previewDisplayName("Add Option Trade Preview")
    }
}

struct AddFutureTrade: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: FutureTradeViewModel  = FutureTradeViewModel() 
    
    
    var body: some View {
        
        Form {
            
            Section(header: Text("Trade Details")) {
                
                TextField("Ticker", text: $viewModel.ticker)
                TextField("Tick Size", text: $viewModel.tickSize)
                    .keyboardType(.decimalPad)
                TextField("Quantity", text: $viewModel.quantity)
                    .keyboardType(.numberPad)
                TextField("Buy Price", text: $viewModel.buyPrice)
                    .keyboardType(.decimalPad)
                TextField("Sell Price (Optional)", text: $viewModel.sellPrice)
                    .keyboardType(.decimalPad)
                Toggle("Is Long", isOn: $viewModel.isLong) // New field for isLong
                TextField("Note (Optional)", text: $viewModel.note)
            }
            

            Button("Save Trade") {
                viewModel.saveTrade()
                dismiss() // Dismiss the view after saving
            }
            .disabled(viewModel.ticker.isEmpty || viewModel.tickSize.isEmpty || viewModel.quantity.isEmpty || viewModel.buyPrice.isEmpty)
        }
        .navigationTitle("Add Future Trade")
    }
}

struct AddStockTrade: View {
    @ObservedObject var viewModel: StockTradeViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section(header: Text("Trade Details")) {
                TextField("Ticker", text: $viewModel.ticker)
                TextField("Quantity", text: $viewModel.quantity)
                    .keyboardType(.numberPad)
                TextField("Buy Price", text: $viewModel.buyPrice)
                    .keyboardType(.decimalPad)
                TextField("Sell Price (Optional)", text: $viewModel.sellPrice)
                    .keyboardType(.decimalPad)
                Toggle("Is Long", isOn: $viewModel.isLong) // New field for isLong
                TextField("Note", text: $viewModel.note)
            }
            
            Button("Save Trade") {
                viewModel.saveTrade()
                dismiss() // Dismiss the view after saving
            }
            .disabled(viewModel.ticker.isEmpty || viewModel.quantity.isEmpty || viewModel.buyPrice.isEmpty)
        }
        .navigationTitle("Add Stock Trade")
    }
}
extension OptionTradeViewModel {
    
    
    var tickerError: String? {
        if ticker.isEmpty {
            return "Ticker is required"
        }
        return nil
    }

    var strikePriceError: String? {
        if strikePrice.isEmpty || !strikePrice.allSatisfy({ $0.isNumber }) {
            return "Strike Price must be a number"
        }
        return nil
    }

    var quantityError: String? {
        if quantity.isEmpty || !quantity.allSatisfy({ $0.isNumber }) {
            return "Quantity must be a number"
        }
        return nil
    }

    var buyPriceError: String? {
        if buyPrice.isEmpty || !buyPrice.allSatisfy({ $0.isNumber }) {
            return "Buy Price must be a number"
        }
        return nil
    }

    var sellPriceError: String? {
        if sellPrice.isEmpty || !sellPrice.allSatisfy({ $0.isNumber }) {
            return "Sell Price must be a number"
        }
        return nil
    }
    func setError(message: String) {
            self.error = message
        }
}

