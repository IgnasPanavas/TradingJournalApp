//
//  ThemeSettings.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 4/13/24.
//

import SwiftUI

struct Theme {
    let backgroundColor: Color
    let textColor: Color
    // ... add more as needed
}


private struct ThemeKey: EnvironmentKey {
    static let defaultValue = Theme(backgroundColor: .white, textColor: .black)
}

extension EnvironmentValues {
    var theme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}
