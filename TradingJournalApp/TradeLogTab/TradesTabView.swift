import CoreData
import SwiftUI

struct TradesTabView: View {
    @State private var selectedTabIndex = 0
    @Binding var showingAddTrade: Bool

    
    var body: some View {
        let tabs: [Tab] = [Tab(title: "Open", view: AnyView(OpenTradesView())), Tab(title: "Closed", view: AnyView(ClosedTradesView()))]
        VStack {
            // Tab Bar
            HStack {
                ForEach(tabs.indices, id: \.self) { index in
                    Button(action: {
                        withAnimation { // Animate the selection change
                            self.selectedTabIndex = index
                        }
                    }) {
                        VStack {
                            Text(tabs[index].title)
                                .padding([.top, .bottom, .leading, .trailing], 5)
                                .foregroundStyle(self.selectedTabIndex == index ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                            // Underline
                            if selectedTabIndex == index {
                                
                                Rectangle()
                                    .frame(height: 2)
                                    .foregroundColor(Color.blue)
                                    .transition(.move(edge: (selectedTabIndex != 0) ? .leading : .trailing)) // Fade transition for the underline
                            }
                        }
                           
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(width: 350)
            .cornerRadius(5)
            VStack {
                tabs[selectedTabIndex].view
            }
            .frame(maxHeight: 550, alignment: .top)
        }
        .frame(maxHeight: 650)
    }
}

struct Tab {
    var title: String
    var view: AnyView
}


