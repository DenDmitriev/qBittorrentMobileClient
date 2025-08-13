//
//  AuthRepository.swift
//  barcelona-ios
//
//  Created by Victor Kostin on 16.12.2024.
//

import Foundation

class AuthRepository: TokenRefreshProvider, AccessCookieProvider {
    private enum Constants {
        static let cookie = "Cookie"
    }
    
    var cookie: String? { UserDefaults.standard.string(forKey: Constants.cookie) }
        
    private lazy var mobileService = MobileService.shared
    
    @discardableResult
    func cookie() async throws -> String {
        return ""
    }
    
    func authorizeUser(login: String, password: String) async throws {
        try await mobileService.request(target: .auth(.login(login: login, password: password)))
    }
}
