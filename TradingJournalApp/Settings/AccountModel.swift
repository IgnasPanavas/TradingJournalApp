//
//  AccountModel.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 3/16/24.
//

import SwiftUI

class AccountModel: ObservableObject {
    @Published var balance: Double = UserDefaults.standard.double(forKey: "accountBalance") {
        didSet {
            UserDefaults.standard.set(balance, forKey: "accountBalance")
        }
    }

    func updateBalance(withProfit profit: Double) {
        balance += profit
    }
}
