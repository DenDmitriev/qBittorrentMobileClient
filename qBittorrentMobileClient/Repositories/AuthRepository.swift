//
//  AuthRepository.swift
//  barcelona-ios
//
//  Created by Victor Kostin on 16.12.2024.
//

import Foundation

@Observable
class AuthRepository {
    var username: String? {
        get {
            UserDefaults.standard.string(forKey: AppStorageKeys.username)
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: AppStorageKeys.username)
        }
    }
    var password: String? {
        get {
            UserDefaults.standard.string(forKey: AppStorageKeys.password)
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: AppStorageKeys.password)
        }
    }
    
    @MainActor var isAuthorized: Bool? = nil
        
    private var mobileService = MobileService.shared
    
    init() {
        mobileService.onAuthRefreshCompletion = { [weak self] isAuthorized in
            print(isAuthorized)
            Task { @MainActor in
                self?.isAuthorized = isAuthorized
            }
        }
    }
    
    @discardableResult
    func authorizeUser() async throws -> Bool {
        guard let username, let password, username.isEmpty == false, password.isEmpty == false else {
            await MainActor.run {
                isAuthorized = false
            }
            throw ServerError.unauthorized(details: .init(statusCode: 400, message: "Username or password is empty"))
        }
        let result = try await mobileService.requestString(target: .auth(.login(login: username, password: password)))
        
        if result.lowercased().contains("ok") { // Ok.
            await MainActor.run {
                isAuthorized = true
            }
            return true
        } else { // Fails.
            await MainActor.run {
                isAuthorized = false
            }
            throw ServerError.unauthorized(details: .init(statusCode: 400, message: "Username or password is incorrect"))
        }
    }
    
    func authorizeUser(username: String, password: String) async throws -> Bool {
        self.username = username
        self.password = password
        return try await authorizeUser()
    }
    
    func logoutUser() {
        username = nil
        password = nil
        Task { @MainActor in
            isAuthorized = false
        }
    }
}
