//
//  DateFormatter.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 3/15/24.
//

import SwiftUI

extension DateFormatter {
    static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd" // MMM for abbreviated month, dd for day
        return formatter
    }()
}
