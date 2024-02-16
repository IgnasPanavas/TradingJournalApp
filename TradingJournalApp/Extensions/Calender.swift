//
//  Calender.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 2/15/24.
//
import SwiftUI

extension Calendar {
    func startOfWeek(for date: Date) -> Date {
        let components = dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return self.date(from: components)!
    }
    
    func endOfWeek(for date: Date) -> Date {
        let startOfWeek = self.startOfWeek(for: date)
        return self.date(byAdding: .day, value: 7, to: startOfWeek)!
    }
}

