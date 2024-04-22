//
//  TradingJournalAppApp.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 2/6/24.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

@main
struct TradingJournalApp: App {
    @State private var showOnboarding = true
    @StateObject var authenticationManager = AuthenticationManager()
        
    
    let dataController = DataController.shared
    

    let mainTabView = MainTabView()
    
    init() {
        FirebaseApp.configure()
        }
    var body: some Scene {
        WindowGroup {
                ContentView()
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .environmentObject(SignInViewModel())
                    .environmentObject(AccountModel())
                    
                    .opacity(authenticationManager.isAuthenticationSuccessful ? 1 : 0.2)
                    .onAppear {
                        authenticationManager.authenticate()
                    }
                    .disabled(!authenticationManager.isAuthenticationSuccessful)
        }
    }
}

