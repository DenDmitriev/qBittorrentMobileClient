//
//  MainTabView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 25.08.2025.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabItem = .main
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(TabItem.main.title, systemImage: "house", value: .main) {
                MainView()
            }
            Tab(TabItem.settings.title, systemImage: "gear", value: .settings) {
                SettingsView()
            }
        }
    }
}

#Preview {
    MainTabView()
}
