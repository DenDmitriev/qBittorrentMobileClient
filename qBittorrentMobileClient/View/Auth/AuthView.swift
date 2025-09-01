//
//  AuthView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 14.08.2025.
//

import SwiftUI

enum AuthError: LocalizedError {
    case serverUrlFailure
    
    var errorDescription: String? {
        switch self {
        case .serverUrlFailure:
            return String(localized: "Please enter a valid URL (e.g., http://192.168.100.31:8080)")
        }
    }
}

struct AuthView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AuthRepository.self) private var authRepository
    @AppStorage(AppStorageKeys.username) private var username: String = ""
    @AppStorage(AppStorageKeys.password) private var password: String = ""
    @AppStorage(AppStorageKeys.serverUrl) private var serverUrl: URL?
    @State private var serverUrlString: String = ""
    @State private var error: AuthError?
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(.qbittorrentLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                VStack {
                    Text("Server")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    TextField("Enter server URL", text: $serverUrlString)
                        .keyboardType(.URL)
                        .textContentType(.URL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .onChange(of: serverUrlString) { _, newValue in
                            validateUrl(newValue)
                        }
                }
                
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
                        .disabled(isLoginDisabled)
                }
            }
        }
        .onAppear {
            if let serverUrl {
                serverUrlString = serverUrl.absoluteString
            }
        }
    }
    
    private var isLoginDisabled: Bool {
        serverUrl == nil || serverUrlString.isEmpty || error != nil
    }
    
    private func validateUrl(_ urlString: String) {
        error = nil
        
        var formattedUrl = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Добавляем http://, если схема не указана
        if !formattedUrl.hasPrefix("http://") && !formattedUrl.hasPrefix("https://") {
            formattedUrl = "http://" + formattedUrl
        }
        
        // Проверяем, является ли строка валидным URL
        if let url = URL(string: formattedUrl), url.scheme != nil, url.host != nil {
            serverUrl = url
        } else {
            error = .serverUrlFailure
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
