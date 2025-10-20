import Foundation
import Moya
import Alamofire

class CustomAlamofireSession: Alamofire.Session, @unchecked Sendable {
    static let shared: CustomAlamofireSession = {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default  // Стандартные заголовки HTTP
        configuration.timeoutIntervalForRequest = 3.0  // Таймаут для запроса в секундах (например, 3 сек)
        configuration.timeoutIntervalForResource = 6.0 // Таймаут для всего ресурса (опционально, например, 6 сек)
        configuration.requestCachePolicy = .useProtocolCachePolicy  // Политика кэширования
        
        return CustomAlamofireSession(configuration: configuration)
    }()
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
            session: CustomAlamofireSession.shared, // Before Session()
            plugins: [LoggerPlugin.instance]
        )
                
        super.init(
            apiProvider: apiProvider,
            authRefreshProvider: authRefresher
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
