//
//  Authentication.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 4/13/24.
//

import LocalAuthentication
import Combine

class AuthenticationManager: ObservableObject {
    @Published var isAuthenticationSuccessful: Bool = false
    @Published var errorMessage: String?

    func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            // Use .deviceOwnerAuthenticationWithBiometrics here to prioritize Face ID
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.isAuthenticationSuccessful = true
                    } else {
                        self.errorMessage = authenticationError?.localizedDescription ?? "Failed to authenticate"
                    }
                }
            }
        } else {
            // No biometrics available, go to passcode
            let reason = "Enter your passcode"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.isAuthenticationSuccessful = true
                    } else {
                        self.errorMessage = authenticationError?.localizedDescription ?? "Failed to authenticate"
                    }
                }
            }
        }
    }
}
