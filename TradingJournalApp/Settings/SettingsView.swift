import SwiftUI
import CoreData

struct SettingsView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var authModel: SignInViewModel
    @EnvironmentObject var accountModel: AccountModel

    @State private var showAccountDetails: Bool = false
    @State private var showTradeDetails: Bool = false
    @AppStorage("startingAccountBalance") var startingAccountBalance: String = ""
    @AppStorage("notifOn") var notifOn: Bool = false
    @AppStorage("defaultTradeType") var defaultTradeType: String = "Stocks"
    @AppStorage("defaultQuantity") var defaultQuantityString: String = ""
    @AppStorage("showSymbolPrefix") var showSymbolPrefix: Bool = true
    @AppStorage("dateFormat") var dateFormat: String = "MM/dd/yyyy"
    @AppStorage("timeFormat") var timeFormat: String = "HH:mm"
    @AppStorage("showDecimalPlaces") var showDecimalPlaces: Bool = true
    @AppStorage("weeklyProfitTarget") var weeklyProfitTarget: String = ""

    var body: some View {
        NavigationView {
       
                
   
            List {
                Section(header: Text("User Data")) {           UserDataView()        }
                Section(header: Text("Account Settings")) {
                    TextField("Enter starting account balance", text: $startingAccountBalance)
                                .keyboardType(.decimalPad)

                    Toggle("Enable Notifications", isOn: $notifOn)
                        
                }

                Section(header: Text("Trade Settings")) {
                    SettingsItem(label: "Default Trade Type", navLinkDest: {
                        TradeTypeSelectorView(selectedTradeType: $defaultTradeType)
                    })

                    SettingsItem(label: "Default Quantity", navLinkDest: {
                        TextField("Default Quantity", text: $defaultQuantityString)
                            .keyboardType(.numberPad)
                            
                    })

                    SettingsItem(label: "Weekly Profit Target", navLinkDest: {
                        TextField("Weekly Profit Target", text: $weeklyProfitTarget)
                            .keyboardType(.decimalPad)
                    })

                    Toggle("Show Symbol Prefix", isOn: $showSymbolPrefix)
                }

                Section(header: Text("Display Settings")) {
                    Picker("Date Format", selection: $dateFormat) {
                        Text("MM/dd/yyyy").tag("MM/dd/yyyy")
                        Text("dd/MM/yyyy").tag("dd/MM/yyyy")
                        Text("yyyy/MM/dd").tag("yyyy/MM/dd")
                    }

                    Picker("Time Format", selection: $timeFormat) {
                        Text("HH:mm").tag("HH:mm")
                        Text("hh:mma").tag("hh:mma")
                        Text("12:HH").tag("12:HH") //Assuming you meant HH:mm in 12-hour format
                    }

                    Toggle("Show Decimal Places", isOn: $showDecimalPlaces)
                }
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing: Button(action: {
                authModel.signOut()
            }) {
                Text("Logout")
            }.buttonStyle(BorderlessButtonStyle()))
        }
        .sheet(isPresented: $showAccountDetails) {
            AccountDetailsView()
        }
        .sheet(isPresented: $showTradeDetails) {
            TradeDetailsView()
        }
        .onAppear {
            if let balance = UserDefaults.standard.string(forKey: "startingAccountBalance") {
                startingAccountBalance = balance
            }
            if let tradeType = UserDefaults.standard.string(forKey: "defaultTradeType") {
                defaultTradeType = tradeType
            }
            if let quantity = UserDefaults.standard.object(forKey: "defaultQuantity") as? Int {
                self.defaultQuantityString = "\(quantity)"
            }
            if let showSymbolPrefix = UserDefaults.standard.object(forKey: "showSymbolPrefix") as? Bool {
                self.showSymbolPrefix = showSymbolPrefix
            }
            if let dateFormat = UserDefaults.standard.string(forKey: "dateFormat") {
                self.dateFormat = dateFormat
            }
            if let timeFormat = UserDefaults.standard.string(forKey: "timeFormat") {
                self.timeFormat = timeFormat
            }
            if let showDecimalPlaces = UserDefaults.standard.object(forKey: "showDecimalPlaces") as? Bool {
                self.showDecimalPlaces = showDecimalPlaces
            }
        }
    }
}

struct SettingsItem<Content: View>: View {
    var label: String
    var navLinkDest: () -> Content

    var body: some View {
        NavigationLink(destination: navLinkDest()) {
            Text(label)
        }
    }
}

struct TradeTypeSelectorView: View {
    @Binding var selectedTradeType: String

    var body: some View {
        HStack {
            Text("Default Trade Type:")
            Picker("", selection: $selectedTradeType) {
                Text("Stocks")
                Text("Options")
                Text("Futures")
            }
        }
    }
}

struct AccountDetailsView: View {
    // Add account settings here
    var body: some View {
        Text("Account Details")
    }
}

struct TradeDetailsView: View {
    // Add trade settings here
    var body: some View {
        Text("Trade Details")
    }
}

struct SettingsView_Preview: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
