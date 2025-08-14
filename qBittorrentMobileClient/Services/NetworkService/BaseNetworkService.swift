import Foundation
import Moya

typealias MoyaProvider = Moya.MoyaProvider

protocol NetworkService {
    associatedtype Target: MobileApiTargetType
    
    var onAuthRefreshFailed: (() -> Void)? { get set }
    
    func request<T: Decodable>(target: Target) async throws -> T
    func request(target: Target) async throws
}

protocol AuthRefreshProvider {
    var username: String? { get }
    var password: String? { get }
    
    func authorizeUser() async throws -> Bool
}

class BaseNetworkService<Target: MobileApiTargetType>: NetworkService {
    var onAuthRefreshFailed: (() -> Void)? { didSet { onceExecutor = OnceExecutor() } }
    
    private let apiProvider: MoyaProvider<Target>
    private let authRefresher: AuthRefresher
    private var onceExecutor: OnceExecutor?
    
    init(
        apiProvider: MoyaProvider<Target>,
        authRefreshProvider: AuthRefreshProvider
    ) {
        self.apiProvider = apiProvider
        self.authRefresher = AuthRefresher(authRefreshProvider: authRefreshProvider)
    }
    
    func request<T: Decodable>(target: Target) async throws -> T {
        Log.authRefreshFlow.debug(logEntry: .text("NetworkService. Request \(target) started"))
        
        do {
            return try await apiProvider.request(target: target)
        } catch {
            try _Concurrency.Task.checkCancellation()
            
            if
                let serverError = error as? ServerError,
                case .unauthorized = serverError
            {
                try await authRefresh()
                Log.authRefreshFlow.debug(logEntry: .text("NetworkService. Request \(target) started"))
                return try await apiProvider.request(target: target)
            } else {
                let logText = "NetworkService. Request \(target) failed with error \(error)"
                Log.authRefreshFlow.debug(logEntry: .text(logText))
                
                throw error
            }
        }
    }
    
    func requestString(target: Target) async throws -> String {
        Log.authRefreshFlow.debug(logEntry: .text("NetworkService. Request \(target) started"))
        
        do {
            return try await apiProvider.request(target: target)
        } catch {
            try _Concurrency.Task.checkCancellation()
            
            if
                let serverError = error as? ServerError,
                case .unauthorized = serverError
            {
                try await authRefresh()
                Log.authRefreshFlow.debug(logEntry: .text("NetworkService. Request \(target) started"))
                return try await apiProvider.request(target: target)
            } else {
                let logText = "NetworkService. Request \(target) failed with error \(error)"
                Log.authRefreshFlow.debug(logEntry: .text(logText))
                
                throw error
            }
        }
    }
    
    func request(target: Target) async throws {
        Log.authRefreshFlow.debug(logEntry: .text("NetworkService. Request \(target) started"))
        
        do {
            return try await apiProvider.request(target: target)
        } catch {
            try _Concurrency.Task.checkCancellation()
            
            if
                let serverError = error as? ServerError,
                case .forbidden = serverError
            {
                try await authRefresh()
                Log.authRefreshFlow.debug(logEntry: .text("NetworkService. Request \(target) started"))
                return try await apiProvider.request(target: target)
            } else {
                let logText = "NetworkService. Request \(target) failed with error \(error)"
                Log.authRefreshFlow.debug(logEntry: .text(logText))
                
                throw error
            }
        }
    }
    
    private func authRefresh() async throws {
        do {
            try await authRefresher.refreshToken()
        } catch let error {
            try _Concurrency.Task.checkCancellation()
            
            if let serverError = error as? ServerError,
               case .forbidden = serverError {
                await onceExecutor?.runOnce { [weak self] in
                    self?.onAuthRefreshFailed?()
                    Log.authRefreshFlow.debug(logEntry: .text("NetworkService. Send onAuthRefreshFailed"))
                }
            }
            
            if let serverError = error as? ServerError,
               case .tokenExpired = serverError {
                await onceExecutor?.runOnce { [weak self] in
                    self?.onAuthRefreshFailed?()
                    Log.authRefreshFlow.debug(logEntry: .text("NetworkService. Send onAuthRefreshFailed"))
                }
            }
                           
            Log.authRefreshFlow.debug(logEntry: .text("NetworkService. AuthRefresh request failed. \(error)"))
            throw error
        }
    }
}

private extension BaseNetworkService {
    actor AuthRefresher {
        private let authRefreshProvider: AuthRefreshProvider
        private var refreshAuthTask: _Concurrency.Task<Void, Error>?
                
        init(authRefreshProvider: AuthRefreshProvider) {
            self.authRefreshProvider = authRefreshProvider
        }

        func refreshToken() async throws {
            Log.authRefreshFlow.debug(logEntry: .text("NetworkService. AuthRefresh method called"))
            
            if refreshAuthTask == nil {
                refreshAuthTask = _Concurrency.Task {
                    defer { refreshAuthTask = nil }
                    
                    let attempts: Int = 1
                    var lastError: Error?
                    
                    for attempt in 1...attempts {
                        let logText = "NetworkService. AuthRefresh request started with attempt number \(attempt)"
                        Log.authRefreshFlow.debug(logEntry: .text(logText))
                        
                        do {
                            _ = try await authRefreshProvider.authorizeUser()
                            
                            Log.authRefreshFlow.debug(logEntry: .text("NetworkService. AuthRefresh updated"))

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
            
            return try await refreshAuthTask!.value
        }
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
