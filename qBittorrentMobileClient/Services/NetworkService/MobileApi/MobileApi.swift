import Foundation
import Moya

enum MobileApi {
    case auth(AuthApi)
    case torrent(TorrentApi)
    case example(ExampleApi)
}

extension MobileApi: MobileApiTargetType {    
    var baseURL: URL { getBaseUrl() }
    var path: String { getPath() }
    var method: Moya.Method { getMethod() }
    var task: Task { getTask() }
    var formData: [MultipartFormData] { [] }
    var headers: [String: String]? { getHeaders() }
    var sampleData: Data { getSampleData() }

    private func getBaseUrl() -> URL {
        switch self {
        case .example(let type as MobileApiTargetType),
                .auth(let type as MobileApiTargetType),
                .torrent(let type as MobileApiTargetType):
            return type.baseURL
        }
    }

    private func getPath() -> String {
        switch self {
        case .example(let type as MobileApiTargetType),
                .auth(let type as MobileApiTargetType),
                .torrent(let type as MobileApiTargetType):
            return type.path
        }
    }

    private func getMethod() -> Moya.Method {
        switch self {
        case .example(let type as MobileApiTargetType),
                .auth(let type as MobileApiTargetType),
                .torrent(let type as MobileApiTargetType):
            return type.method
        }
    }

    private func getTask() -> Task {
        switch self {
        case .example(let type as MobileApiTargetType),
                .auth(let type as MobileApiTargetType),
                .torrent(let type as MobileApiTargetType):
            return type.task
        }
    }

    private func getHeaders() -> [String: String]? {
        var headers: [String: String] = [:]
        
        let additionalHeaders: [String: String]?
        
        switch self {
        case .example(let target as MobileApiTargetType),
                .auth(let target as MobileApiTargetType),
                .torrent(let target as MobileApiTargetType):
            additionalHeaders = target.headers
        }

        if let additionalHeaders {
            additionalHeaders.forEach {
                headers[$0.key] = $0.value
            }
        }

        return headers
    }
    
    private func getSampleData() -> Data {
        switch self {
        case .auth(let authApi):
            return authApi.sampleData
        case .example(let exampleApi):
            return exampleApi.sampleData
        case .torrent(let torrentApi):
            return torrentApi.sampleData
        }
    }
}
