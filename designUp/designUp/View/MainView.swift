//
//  MainView.swift
//  designUp
//
//  Created by София Кармаева on 27/3/2025.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Group {
                FeedView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("главная")
                    }
                    .tag(0)

                ProfileView()
                    .tabItem {
                        Image(systemName: "person")
                        Text("профиль")
                    }
                    .tag(1)
            }
            .toolbarBackground(.visible, for: .tabBar)
        }
        .accentColor(selectedTab == 0 ? .brightPink : .brightPurple)
    }
}

//#Preview {
//    MainView()
//}
