import Foundation
import Moya

enum ExampleApi {
    case testItems
}

extension ExampleApi: MobileApiTargetType {
    var baseURL: URL { getBaseURL() }
    var path: String { getPath() }
    var method: Moya.Method { getMethod() }
    var task: Moya.Task { getTask() }
    var formData: [MultipartFormData] { getFormData() }
    var headers: [String: String]? { getHeaders() }
    var authorizationType: Moya.AuthorizationType? { .none }
        
    private func getBaseURL() -> URL { URL(string: "http://mediaserver.local:8080")! }
    
    private func getPath() -> String {
        switch self {
        case .testItems:
            return "/chains.json"
        }
    }
    
    private func getMethod() -> Moya.Method {
        switch self {
        case .testItems:
            return .get
        }
    }
    
    private func getTask() -> Moya.Task {
        switch self {
        case .testItems:
            return .requestPlain
        }
    }
    
    private func getFormData() -> [MultipartFormData] {
        switch self {
        case .testItems:
            break
        }
        
        return []
    }
    
    private func getHeaders() -> [String: String]? {
        let headers: [String: String] = [:]
        
        return headers
    }
}
