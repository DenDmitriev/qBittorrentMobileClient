//
//  MainView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 25.08.2025.
//

import SwiftUI

struct MainView: View {
    @Environment(AuthRepository.self) private var authRepository
    
    @State private var navigationModel: NavigationModel = .init()
    @State private var error: Error?
    
    var body: some View {
        if authRepository.isAuthorized ?? false {
            NavigationStack(path: $navigationModel.path) {
                TorrentsView()
                    .navigationDestination(for: Router.self) { route in
                        Router.destination(route: route)
                    }
            }
            .environment(navigationModel)
        } else {
            VStack {
                ProgressView()
                if let error {
                    Text(error.localizedDescription)
                }
                Button(String(localized: "Retry")) {
                    checkConnection()
                }
            }
            .onAppear {
                checkConnection()
            }
        }
    }
    
    private func checkConnection() {
        Task {
            do {
                try await authRepository.authorizeUser()
            } catch {
                await MainActor.run {
                    self.error = error
                }
            }
        }
    }
}

#Preview {
    MainView()
        .environment(AuthRepository())
}
