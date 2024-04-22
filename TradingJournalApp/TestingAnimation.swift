import SwiftUI

struct ContentView1: View {
    @State private var scrollOffset: CGFloat = 0
    
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack {
                        
                        // Your scrollable content here
                        ForEach(0..<30) { _ in
                            Text("Sample Row")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.top, 1) // Trigger initial offset calculation
                    .background(
                        GeometryReader { geo in
                            Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: geo.frame(in: .named("scrollView")).minY)
                        }
                    )
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) {
                        value in
                        withAnimation {
                            scrollOffset = value
                        }
                    }
                }
                .coordinateSpace(name: "scrollView")
                .navigationTitle("Dynamic Title")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        VStack {
                            Text("Dynamic Title")
                                .font(.largeTitle.bold())
                                .animation(.default, value: scrollOffset)
                                .scaleEffect(scrollOffset + 100 < 100 ? 0.6 : 1)
                               
                            Spacer()
                        }
                        .id(UUID()) // Unique identifier for the title view
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {}) {
                            Image(systemName: "arrow.left")
                                .font(.title2)
                                .offset(x: scrollOffset > 0 ? -10 : 0, y: 0)
                        }
                    }
                }
            }
        }
    }
}

struct ScrollOffsetPreferenceKey1: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView1()
    }
}
