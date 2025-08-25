//
//  AuthView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 14.08.2025.
//

import SwiftUI

struct AuthView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AuthRepository.self) private var authRepository
    @AppStorage(AppStorageKeys.username) private var username: String = ""
    @AppStorage(AppStorageKeys.password) private var password: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(.qbittorrentLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                VStack {
                    Text("Authorization")
                        .font(.title)
                    TextField("Username", text: $username)
                        .textInputAutocapitalization(.never)
                    SecureField("Password", text: $password)
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("Log in", action: login)
                        .buttonStyle(.borderedProminent)
                }
            }
        }
    }
    
    private func login() {
        Task {
            let isAuthorized = try await authRepository.authorizeUser(username: username, password: password)
            await MainActor.run {
                if isAuthorized {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AuthView()
        .environment(AuthRepository())
}
