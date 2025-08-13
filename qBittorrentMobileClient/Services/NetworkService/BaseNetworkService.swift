import Foundation
import Moya

typealias MoyaProvider = Moya.MoyaProvider

protocol NetworkService {
    associatedtype Target: MobileApiTargetType
    
    var onTokenRefreshFailed: (() -> Void)? { get set }
    
    func request<T: Decodable>(target: Target) async throws -> T
    func request(target: Target) async throws
}

protocol TokenRefreshProvider {
    @discardableResult
    func cookie() async throws -> String
}

class BaseNetworkService<Target: MobileApiTargetType>: NetworkService {
    var onTokenRefreshFailed: (() -> Void)? { didSet { onceExecutor = OnceExecutor() } }
    
    private let apiProvider: MoyaProvider<Target>
    private let tokenRefresher: TokenRefresher
    private var onceExecutor: OnceExecutor?
    
    init(
        apiProvider: MoyaProvider<Target>,
        tokenRefreshProvider: TokenRefreshProvider
    ) {
        self.apiProvider = apiProvider
        self.tokenRefresher = TokenRefresher(tokenRefreshProvider: tokenRefreshProvider)
    }
    
    func request<T: Decodable>(target: Target) async throws -> T {
        Log.refreshTokenFlow.debug(logEntry: .text("NetworkService. Request \(target) started"))
        
        do {
            return try await apiProvider.request(target: target)
        } catch {
            try _Concurrency.Task.checkCancellation()
            
            if
                let serverError = error as? ServerError,
                case .unauthorized = serverError
            {
                try await refreshToken()
                Log.refreshTokenFlow.debug(logEntry: .text("NetworkService. Request \(target) started"))
                return try await apiProvider.request(target: target)
            } else {
                let logText = "NetworkService. Request \(target) failed with error \(error)"
                Log.refreshTokenFlow.debug(logEntry: .text(logText))
                
                throw error
            }
        }
    }
    
    func request(target: Target) async throws {
        Log.refreshTokenFlow.debug(logEntry: .text("NetworkService. Request \(target) started"))
        
        do {
            return try await apiProvider.request(target: target)
        } catch {
            try _Concurrency.Task.checkCancellation()
            
            if
                let serverError = error as? ServerError,
                case .unauthorized = serverError
            {
                try await refreshToken()
                Log.refreshTokenFlow.debug(logEntry: .text("NetworkService. Request \(target) started"))
                return try await apiProvider.request(target: target)
            } else {
                let logText = "NetworkService. Request \(target) failed with error \(error)"
                Log.refreshTokenFlow.debug(logEntry: .text(logText))
                
                throw error
            }
        }
    }
    
    private func refreshToken() async throws {
        do {
            try await tokenRefresher.refreshToken()
        } catch let error {
            try _Concurrency.Task.checkCancellation()
            
            if let serverError = error as? ServerError,
               case .unauthorized = serverError {
                await onceExecutor?.runOnce { [weak self] in
                    self?.onTokenRefreshFailed?()
                    Log.refreshTokenFlow.debug(logEntry: .text("NetworkService. Send onTokenRefreshFailed"))
                }
            }
            
            if let serverError = error as? ServerError,
               case .tokenExpired = serverError {
                await onceExecutor?.runOnce { [weak self] in
                    self?.onTokenRefreshFailed?()
                    Log.refreshTokenFlow.debug(logEntry: .text("NetworkService. Send onTokenRefreshFailed"))
                }
            }
                           
            Log.refreshTokenFlow.debug(logEntry: .text("NetworkService. RefreshToken request failed. \(error)"))
            throw error
        }
    }
}

private extension BaseNetworkService {
    actor TokenRefresher {
        private let tokenRefreshProvider: TokenRefreshProvider
        private var refreshTokenTask: _Concurrency.Task<Void, Error>?
                
        init(tokenRefreshProvider: TokenRefreshProvider) {
            self.tokenRefreshProvider = tokenRefreshProvider
        }

        // swiftlint:disable force_unwrapping
        func refreshToken() async throws {
            Log.refreshTokenFlow.debug(logEntry: .text("NetworkService. RefreshToken method called"))
            
            if refreshTokenTask == nil {
                refreshTokenTask = _Concurrency.Task {
                    defer { refreshTokenTask = nil }
                    
                    let attempts: Int = 1
                    var lastError: Error?
                    
                    for attempt in 1...attempts {
                        let logText = "NetworkService. RefreshToken request started with attempt number \(attempt)"
                        Log.refreshTokenFlow.debug(logEntry: .text(logText))
                        
                        do {
                            _ = try await tokenRefreshProvider.cookie()
                            
                            Log.refreshTokenFlow.debug(logEntry: .text("NetworkService. RefreshToken updated"))

                            lastError = nil
                            
                            break
                        } catch {
                            lastError = error
                        }
                    }
                    
                    if let lastError {
                        throw lastError
                    }
                }
            }
            
            return try await refreshTokenTask!.value
        }
        // swiftlint:enable force_unwrapping
    }
    
    actor OnceExecutor {
        private var hasRun = false

        func runOnce(task: () async -> Void) async {
            guard hasRun == false else {
                return
            }
            
            hasRun = true
            
            await task()
        }
    }
}
