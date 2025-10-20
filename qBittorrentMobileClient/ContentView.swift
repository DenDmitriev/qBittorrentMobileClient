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
    @State private var error: LocalizedError?
    
    var body: some View {
        if authRepository.isAuthorized == nil {
            LaunchView()
        } else {
            MainTabView()
                .fullScreenCover(isPresented: isAuthorizationPresented) {
                    AuthView()
                }
                .addToast { item in ToastView(item: item) }
        }
    }
    
    private var isAuthorizationPresented: Binding<Bool> { Binding(
        get: {
            guard
                serverUrl != nil,
                authRepository.isAuthorized ?? false
            else {
                return true
            }
            return false
        },
        set: { _ in })
    }
}

#Preview {
    ContentView()
        .environment(AuthRepository())
        .environment(ToastRouter())
}
