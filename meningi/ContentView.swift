import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

            SymptomsView()
                .tabItem {
                    Label("Check", systemImage: "stethoscope")
                }
                .tag(1)

            LearnView()
                .tabItem {
                    Label("Learn", systemImage: "book")
                }
                .tag(2)

            MoreView()
                .tabItem {
                    Label("More", systemImage: "line.3.horizontal")
                }
                .tag(3)
        }
    }
}

#Preview {
    ContentView()
}
