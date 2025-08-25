import Foundation
import Moya
import Alamofire

struct SessionSetupParameters {
    let urlSessionConfiguration: URLSessionConfiguration
    let sessionDelegate: SessionDelegate
    let delegateQueue: OperationQueue
    let underlyingDelegateQueue: DispatchQueue
}

class MobileService: BaseNetworkService<MobileApi> {
    static let shared = MobileService()
        
    private init() {
        let authRefresher = AuthRefresher()
        
        let stubClosure = { (target: MobileApi) -> Moya.StubBehavior in
            return .never
        }
        
        let apiProvider = MoyaProvider<MobileApi>(
            stubClosure: stubClosure,
            session: Session.defaultWithoutCache ?? Session(),
            plugins: [LoggerPlugin.instance]
        )
                
        super.init(
            apiProvider: apiProvider,
            authRefreshProvider: authRefresher
        )
    }
    
    static func prepareForSessionConfiguration() -> SessionSetupParameters {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.urlCache = nil
        
        let sessionDelegate = SessionDelegate()
        
        /// Целевая очередь, на которой выполняются блоки кода.
        let rootQueue = DispatchQueue(label: "org.alamofire.session.rootQueue")
        
        /// Очередь из GCD, которую OperationQueue использует для вызова операций.
        let serialRootQueue = DispatchQueue(label: rootQueue.label, target: rootQueue)
        
        /// Очередь, используемая библиотекой Pulse, для настройки URLSessionProxy.
        let delegateQueue = OperationQueue(
            maxConcurrentOperationCount: 1,
            underlyingQueue: serialRootQueue,
            name: "\(serialRootQueue.label).sessionDelegate"
        )
                        
        return SessionSetupParameters(
            urlSessionConfiguration: configuration,
            sessionDelegate: sessionDelegate,
            delegateQueue: delegateQueue,
            underlyingDelegateQueue: serialRootQueue
        )
    }
}

private extension OperationQueue {
    /// инициализатор заимствован из файла OperationQueue+Alamofire.swift библиотеки Alamofire
    /// используется при создании delegateQueue, который нужен, чтобы инициализировать Session
    /// аналогично тому, как это реализовано в самом Alamofire
    convenience init(
        qualityOfService: QualityOfService = .default,
        maxConcurrentOperationCount: Int = OperationQueue.defaultMaxConcurrentOperationCount,
        underlyingQueue: DispatchQueue? = nil,
        name: String? = nil,
        startSuspended: Bool = false
    ) {
        self.init()
        self.qualityOfService = qualityOfService
        self.maxConcurrentOperationCount = maxConcurrentOperationCount
        self.underlyingQueue = underlyingQueue
        self.name = name
        isSuspended = startSuspended
    }
}
