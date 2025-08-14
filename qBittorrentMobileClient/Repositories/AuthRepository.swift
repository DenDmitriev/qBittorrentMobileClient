//
//  AuthRepository.swift
//  barcelona-ios
//
//  Created by Victor Kostin on 16.12.2024.
//

import Foundation

class AuthRepository: AuthRefreshProvider {
    var username: String? {
        didSet { UserDefaults.standard.string(forKey: AppStorageKeys.username) }
    }
    var password: String? {
        didSet { UserDefaults.standard.string(forKey: AppStorageKeys.password) }
    }
        
    private lazy var mobileService = MobileService.shared
    
    @discardableResult
    func authorizeUser() async throws -> Bool {
        guard let username, let password else {
            throw ServerError.unauthorized(details: .init(statusCode: 400, message: "Username or password is empty"))
        }
        let result = try await mobileService.requestString(target: .auth(.login(login: username, password: password)))
        
        if result.lowercased().contains("ok") {
            return true
        } else {
            throw ServerError.unauthorized(details: .init(statusCode: 401, message: "Username or password is incorrect"))
        }
    }
    
    func authorizeUser(username: String, password: String) async throws -> Bool {
        self.username = username
        self.password = password
        return try await authorizeUser()
    }
}
