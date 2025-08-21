//
//  ContentView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 13.08.2025.
//

import SwiftUI

struct ContentView: View {
    private let authRepository = AuthRepository()
    @State private var isAuthorized: Bool?
    
    var body: some View {
        Group {
            if isAuthorized == nil {
                LaunchView()
            } else if let isAuthorized, isAuthorized == false {
                AuthView(isAuthorized: $isAuthorized)
            } else {
                TorrentsView()
            }
        }
        .task {
            await login()
        }
    }
    
    private func login() async {
        do {
            let isAuthorized = try await authRepository.authorizeUser()
            await MainActor.run {
                self.isAuthorized = isAuthorized
            }
        } catch {
            await MainActor.run {
                self.isAuthorized = false
            }
        }
    }
}

#Preview {
    ContentView()
}
