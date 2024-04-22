//
//  SignInError.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 3/17/24.
//

import SwiftUI

enum SignInError: Error {
    case clientIDNotFound
    case signInError(String)
    case unknownError
}
