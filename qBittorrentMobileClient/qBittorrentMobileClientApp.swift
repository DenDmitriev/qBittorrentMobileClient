//
//  qBittorrentMobileClientApp.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 13.08.2025.
//

import SwiftUI

@main
struct qBittorrentMobileClientApp: App {
    @State private var authRepository = AuthRepository()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authRepository)
        }
    }
}
