//
//  ContentView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 13.08.2025.
//

import SwiftUI

struct ContentView: View {
    @Environment(AuthRepository.self) private var authRepository
    @AppStorage(AppStorageKeys.serverUrl) private var serverUrl: URL?
    
    var body: some View {
        MainTabView()
            .fullScreenCover(isPresented: isAuthorizationPresented) {
                AuthView()
            }
            .addToast { item in ToastView(item: item) }
            .environment(authRepository)
    }
    
    private var isAuthorizationPresented: Binding<Bool> { Binding(
        get: {
            guard
                serverUrl != nil,
                let isAuthorized = authRepository.isAuthorized
            else {
                return true
            }
            return !isAuthorized
        },
        set: { _ in })
    }
}

#Preview {
    ContentView()
        .environment(AuthRepository())
        .environment(ToastRouter())
}
