//
//  HomeScreen.swift
//  TradingJournal
//
//  Created by Ignas Panavas on 2/6/24.
//

import SwiftUI

struct HomeScreen: View {
    
    var topText: String?
    
    var body: some View {
        VStack {
            Text(topText ?? "Welcome")
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        // You can create multiple previews here
        Group {
            // Preview with default text
            HomeScreen()

        }
    }
}
