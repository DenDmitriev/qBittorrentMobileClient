//
//  SettingsView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 25.08.2025.
//

import SwiftUI

struct SettingsView: View {
    @State private var navigationModel: NavigationModel = .init()
    
    var body: some View {
        NavigationStack(path: $navigationModel.path) {
            List {
                NavigationLink(String(localized: "Account"), value: Router.accountSettings)
                NavigationLink(String(localized: "Torrent"), value: Router.torrentSettings)
            }
            .navigationTitle(String(localized: "Settings"))
            .navigationDestination(for: Router.self) { route in
                Router.destination(route: route)
            }
        }
        .environment(navigationModel)
    }
}

#Preview {
    SettingsView()
}
