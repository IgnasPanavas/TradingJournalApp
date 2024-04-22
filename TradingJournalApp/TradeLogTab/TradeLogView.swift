//
//  TradeLogView.swift
//  TradingJournalApp
//
//  Created by Ignas Panavas on 2/6/24.
//

import SwiftUI
import CoreData

struct TradeLogView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingAddTrade: Bool = false
    @State var scrollOffset: Double = 0
    @State private var bottomButtonOpacity: Double = 1
    @State private var bottomButtonYOffset: CGFloat = 0
    @State private var floatingButtonOpacity: Double = 0
    @State private var floatingButtonYOffset: CGFloat = 100
    // FetchRequest with sorting by date
    @FetchRequest(
        entity: OptionTrade.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \OptionTrade.date, ascending: false)]
        // Set to false if you want descending order
    ) var optionTrades: FetchedResults<OptionTrade>
    
    var body: some View {
        ZStack {
            // Background rectangle
            Rectangle()
                .foregroundStyle(Color.black)
                .ignoresSafeArea()
            
            GeometryReader { geometry in // Main content with the scrollview and other views
                VStack {
                        HStack {
                            Spacer()
                            Text("Recent Trades")
                                .font(.title)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding()
                        .foregroundColor(.white)
                        
                        TradesTabView(showingAddTrade: $showingAddTrade)
                            .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: { value in
                                scrollOffset = value
                            })
                        
                    
                    
                }
                .onChange(of: scrollOffset) { oldValue, newValue in
                    withAnimation {
                        if newValue > 0 {
                            bottomButtonOpacity = 0
                            bottomButtonYOffset = 100
                            floatingButtonOpacity = 1
                            floatingButtonYOffset = 0
                        } else {
                            bottomButtonOpacity = 1
                            bottomButtonYOffset = 0
                            floatingButtonOpacity = 0
                            floatingButtonYOffset = 100
                        }
                    }
                }
                .overlay {
                    HStack {
                        // Bottom button (adjust padding as desired)
                        Button(action: {
                            showingAddTrade.toggle()
                        }) {
                            Text("Add a Trade")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.black)
                                .frame(width: 300)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(20)
                        }
                        .opacity(bottomButtonOpacity)
                        .offset(y: bottomButtonYOffset)
                        .position(x: geometry.size.width / 2, y: geometry.size.height - 80) // Adjusted position

                        // Floating button (adjust padding as desired)
                        Button(action: {
                            showingAddTrade.toggle()
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(Color.white)
                        }
                        .frame(width: 50, height: 50) // Added for consistent sizing
                        .background(Color.black)  // Changed for floating button styling
                        .clipShape(Circle())
                        .padding(.trailing, 30)  // Padding added for right side spacing
                        .opacity(floatingButtonOpacity)
                        .offset(y: floatingButtonYOffset)
                        .position(x: geometry.size.width - 235, y: geometry.size.height -  80)
                    }
                }
               
                
            }
            .sheet(isPresented: $showingAddTrade) {
                AddTrade()
            }
        }
        .frame(width: 400)
    }
}

    



