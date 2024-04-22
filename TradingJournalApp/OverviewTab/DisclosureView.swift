//
//  DisclosureView.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 3/27/24.
//

import Foundation
import SwiftUI

struct DisclosureView: View {
    @Binding var isDisclosureShowing: Bool

    var body: some View {
        ZStack (alignment: .top) { // Modified for sticky header
            Color.black
                .ignoresSafeArea()

            VStack {
                // Custom Header
                HStack {
                    Button (action: {isDisclosureShowing = false}) {
                        Image(systemName: "xmark")
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    Text("Disclosures")
                        .font(.title3)
                        .foregroundColor(.white)
                    
                    Spacer()
                    Image(systemName: "xmark")
                        .padding(.trailing)
                        .opacity(0)
                }
                .padding(.top, 50) // Add top padding to the header
                .background(Color.black) // Ensures the header blends with the background

                ScrollView {
                    
                    VStack(alignment: .leading, spacing: 50) { // Increased spacing between sections
                        Text("Overview")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        VStack(alignment: .leading, spacing: 20) { // Increased spacing within sections
                            Text("• MyApp is a mobile application designed to provide users with convenient access to their trading accounts and real-time balance monitoring.")
                            Text("• As a valued user of MyApp, it's essential to understand the following disclosures concerning the treatment of your personal information and its relation to your trading activities:")
                        }
                        .foregroundColor(.white)

                        // Collection and Use of Personal Data Section
                        Text("Collection and Use of Personal Data")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 10) // Additional padding for section headers

                        VStack(alignment: .leading, spacing: 5) {
                            Text("• We may collect personal data, including:")
                            VStack(alignment: .leading, spacing: 5) { // Nested for sub-bullets
                                Text("- Your name")
                                Text("- Email address")
                                Text("- Phone number")
                                Text("- Other relevant identifiable information")
                            }
                            .padding(.leading, 40) // Indent sub-bullets
                            Text("• The purpose of this data collection is to:")
                            VStack(alignment: .leading, spacing: 2) { // Nested for sub-bullets
                                Text("- Grant you secure access to your trading accounts")
                                Text("- Tailor your in-app experience to your preferences")
                                Text("- Keep you informed about important app updates and changes")
                            }
                            .padding(.leading, 40) // Indent sub-bullets
                        }
                        .foregroundColor(.white)

                        // Sharing of Personal Data Section
                        Text("Sharing of Personal Data")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 10) // Additional padding for section headers

                        VStack(alignment: .leading, spacing: 20) {
                            Text("• MyApp may engage trusted third-party service providers to:")
                            VStack(alignment: .leading, spacing: 2) {
                                Text("- Facilitate the seamless operation of the app")
                                Text("- Enhance the overall user experience")
                                Text("- Deliver targeted advertisements relevant to your interests")
                            }
                            .padding(.leading, 40)
                            Text("• Rest assured that your personal data will NOT be shared with third parties for marketing purposes without obtaining your explicit consent.")
                        }
                        .foregroundColor(.white)
                    }
                    .padding()
                    // Adjusted height
                }
                .frame(height: 750)
                .scrollContentBackground(.hidden)
            }
            
                    }
                    
                }
            }



struct DisclosureView_Previews: PreviewProvider {
    static var previews: some View {
        DisclosureView(isDisclosureShowing: .constant(true))
    }
}
