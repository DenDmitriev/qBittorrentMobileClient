//
//  AuthView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 14.08.2025.
//

import SwiftUI

enum AuthError: LocalizedError, Hashable {
    case serverUrlFailure(String)
    case authFailure(String)
    
    var errorDescription: String? {
        switch self {
        case .serverUrlFailure:
            return String(localized: "Please enter a valid URL (e.g., http://192.168.100.31:8080)")
        case .authFailure(let message):
            return message
        }
    }
}

struct AuthView: View {
    enum Field: Hashable {
        case server
        case username
        case password
    }
    
    @Environment(\.dismiss) private var dismiss
    @Environment(AuthRepository.self) private var authRepository
    @AppStorage(AppStorageKeys.username) private var username: String = ""
    @AppStorage(AppStorageKeys.password) private var password: String = ""
    @AppStorage(AppStorageKeys.serverUrl) private var serverUrl: URL?
    @State private var serverUrlString: String = ""
    @State private var error: AuthError?
    @State private var isLoading = false
    @FocusState private var focusedField: Field?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Image(.qbittorrentLogo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                        .padding(.top, 32)
                    
                    VStack {
                        Text("Welcome to qBittorrent Mobile")
                            .font(.title2)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Enter your qBittorrent URL and username with password to login.")
                            .font(.caption)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    TextField("URL qBittorrent", text: $serverUrlString)
                        .textFieldStyle(.modern)
                        .focused($focusedField, equals: .server)
                        .onSubmit { focusedField = .username }
                        .keyboardType(.URL)
                        .textContentType(.URL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .onChange(of: serverUrlString) { _, newValue in
                            validateUrl(newValue)
                        }
                    TextField("Username", text: $username)
                        .textFieldStyle(.modern)
                        .focused($focusedField, equals: .username)
                        .onSubmit { focusedField = .password }
                        .textInputAutocapitalization(.never)
                    SecureField("Password", text: $password)
                        .textFieldStyle(.modern)
                        .focused($focusedField, equals: .password)
                        .onSubmit { focusedField = nil }
                }
                .padding()
                .tint(.white)
            }
            .background(Color.accentColor)
            .onTapGesture {
                focusedField = nil
            }
        }
        .safeAreaInset(edge: .bottom, content: {
            Button("Login", action: login)
                .buttonStyle(.modernCapsule(.primaryInverse, maxWidth: .infinity))
                .disabled(isLoginDisabled)
                .loading(isLoading)
                .padding(.horizontal)
        })
        .preferredColorScheme(.dark)
        .toast(error: $error)
        .addToast { item in ToastView(item: item) }
        .onAppear {
            if let serverUrl {
                serverUrlString = serverUrl.absoluteString
            }
        }
    }
    
    private var isLoginDisabled: Bool {
        serverUrl == nil
        || serverUrlString.isEmpty
        || error != nil
        || username.isEmpty
        || password.isEmpty
    }
    
    private func validateUrl(_ urlString: String) {
        error = nil
        do {
            serverUrl = try URLFormatter.create(urlString)
        } catch {
            self.error = .serverUrlFailure(error.localizedDescription)
        }
    }
    
    private func login() {
        focusedField = nil
        isLoading = true
        Task {
            do {
                let isAuthorized = try await authRepository.authorizeUser(username: username, password: password)
                await MainActor.run {
                    if isAuthorized {
                        dismiss()
                        isLoading = false
                    }
                }
            } catch {
                await MainActor.run {
                    self.error = .authFailure(error.localizedDescription)
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    AuthView()
        .environment(AuthRepository())
        .environment(ToastRouter())
}
