//
//  LaunchView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 21.08.2025.
//

import SwiftUI

struct LaunchView: View {
    @Environment(AuthRepository.self) private var authRepository
    @State private var error: Error?
    @State private var isLoading = true
    @State private var isAuthorizeShow = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.accentColor
                    .ignoresSafeArea()
                
                Image(.qbittorrentLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(1.5)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2 + 80)
                }
            }
        }
        .overlay(alignment: .bottom) {
            if let error {
                VStack {
                    Text("Something Went Wrong")
                        .font(.system(.title2, weight: .semibold))
                        .foregroundStyle(.secondary)
                    
                    Text(error.localizedDescription)
                        .font(.system(.subheadline))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    
                    // Кнопка повтора
                    Button(action: authorizeUserAutomatic) {
                        Text("Try Again")
                    }
                    .buttonStyle(.modernCapsule(.secondary, maxWidth: .infinity))
                    .loading(isLoading)
                    .padding(.top, 8)
                    
                    // Кнопка перехода к авторизации
                    Button(action: showAuthorizationSheet) {
                        Text("Authorization")
                    }
                    .buttonStyle(.modernCapsule(.primaryInverse, maxWidth: .infinity))
                    .loading(isLoading)
                    .padding(.top, 8)
                }
                .padding(.horizontal)
            }
        }
        .fullScreenCover(isPresented: $isAuthorizeShow) {
            AuthView()
        }
        .preferredColorScheme(.dark)
        .onAppear {
            selectAuthFlow()
        }
    }
    
    private func selectAuthFlow() {
        if authRepository.isFirstStart {
            showAuthorizationSheet()
        } else {
            authorizeUserAutomatic()
        }
    }
    
    private func authorizeUserAutomatic() {
        isLoading = true
        error = nil
        
        Task {
            do {
                try await authRepository.authorizeUser()
                await MainActor.run {
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
    }
    
    private func showAuthorizationSheet() {
        isAuthorizeShow = true
    }
}

#Preview("Progress") {
    LaunchView()
        .environment(AuthRepository())
}

#Preview("Failure") {
    LaunchView()
        .environment(AuthRepository())
}
