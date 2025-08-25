//
//  ContentView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 13.08.2025.
//

import SwiftUI

struct ContentView: View {
    @Environment(AuthRepository.self) private var authRepository
    
    var body: some View {
        MainTabView()
            .fullScreenCover(isPresented: isAuthorizationPresented) {
                AuthView()
            }
            .environment(authRepository)
    }
    
    private var isAuthorizationPresented: Binding<Bool> { Binding(
        get: {
            guard let isAuthorized = authRepository.isAuthorized else {
                return false
            }
            return !isAuthorized
        },
        set: { _ in })
    }
}

#Preview {
    ContentView()
        .environment(AuthRepository())
}
