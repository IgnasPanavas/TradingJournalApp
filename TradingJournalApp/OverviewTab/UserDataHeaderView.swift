//
//  UserDataHeaderView.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 4/9/24.
//

import SwiftUI

struct UserDataHeaderView: View {
    @Binding var isUserDataViewActive: Bool
    @EnvironmentObject var userData: UserViewModel
    @Environment(\.theme) var theme // Inject the theme environment

    var body: some View {
        HStack {
            Image(systemName: "person")
                .font(.system(size: 20))
                .foregroundColor(.white.opacity(0)) // Theme-based color
                .padding(.leading, 10)

            Spacer()

            Text("Hello, User")//\(userData.name.components(separatedBy: " ").first ?? "")")
                .font(.title)
                .foregroundColor(theme.textColor) // Theme-based color

            Spacer()

            AsyncImage(url: URL(string: userData.photoURLString)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
            }
            .onTapGesture {
                isUserDataViewActive = true
            }
        }
    }
}



    
