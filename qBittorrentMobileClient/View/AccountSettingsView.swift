//
//  AccountSettingsView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 25.08.2025.
//

import SwiftUI

struct AccountSettingsView: View {
    @Environment(AuthRepository.self) private var authRepository
    
    var body: some View {
        List {
            Button(String(localized: "Log out"), role: .destructive, action: authRepository.logoutUser)
        }
        .navigationTitle(String(localized: "Account"))
    }
}

#Preview {
    AccountSettingsView()
        .environment(AuthRepository())
}
