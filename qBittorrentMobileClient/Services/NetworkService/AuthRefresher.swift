//
//  AuthRefresher.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 23.08.2025.
//

import SwiftUI

final class AuthRefresher: AuthRefreshProvider {
    @AppStorage(AppStorageKeys.username) var username: String?
    @AppStorage(AppStorageKeys.password) var password: String?
    
    private lazy var mobileService = MobileService.shared
    
    @discardableResult
    func authorizeUser() async throws -> Bool {
        guard let username, let password, username.isEmpty == false, password.isEmpty == false else {
            throw ServerError.unauthorized(details: .init(statusCode: 401, message: "Username or password is empty"))
        }
        let result = try await mobileService.requestString(target: .auth(.login(login: username, password: password)))
        
        if result.lowercased().contains("ok") {
            return true
        } else {
            throw ServerError.unauthorized(details: .init(statusCode: 401, message: "Username or password is incorrect"))
        }
    }
}
