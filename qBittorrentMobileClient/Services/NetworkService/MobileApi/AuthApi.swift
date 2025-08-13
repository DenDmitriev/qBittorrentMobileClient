import Foundation
import Moya

enum AuthApi {
    case login(login: String, password: String)
    case logout
}

extension AuthApi: MobileApiTargetType {
    var baseURL: URL { getBaseURL() }
    var path: String { getPath() }
    var method: Moya.Method { getMethod() }
    var task: Moya.Task { getTask() }
    var formData: [MultipartFormData] { getFormData() }
    var headers: [String: String]? { getHeaders() }
    var authorizationType: Moya.AuthorizationType? { getAuthorizationType() }
    
    private func getBaseURL() -> URL { URL(string: "http://mediaserver.local:8080")! }
    
    private func getPath() -> String {
        switch self {
        case .login:
            return "/api/v2/auth/login"
        case .logout:
            return "/api/v2/auth/logout"
        }
    }
    
    private func getMethod() -> Moya.Method {
        switch self {
        case .login, .logout:
            return .post
        }
    }
    
    private func getTask() -> Moya.Task {
        switch self {
        case .login:
            return .uploadMultipart(getFormData())
        case .logout:
            return .requestPlain
        }
    }
    
    private func getFormData() -> [MultipartFormData] {
        var multipartData = [MultipartFormData]()
        
        switch self {
        case .login(let login, let password):
            multipartData.append(contentsOf: [
                MultipartFormData(provider: .data(login.data(using: .utf8)!), name: "username"),
                MultipartFormData(provider: .data(password.data(using: .utf8)!), name: "password")
            ])
        case .logout:
            break
        }
        
        return multipartData
    }
    
    private func getHeaders() -> [String: String]? {
        switch self {
        case .login,
                .logout:
            return [:]
        }
    }
    
    private func getAuthorizationType() -> AuthorizationType? {
        switch self {
        case .login,
                .logout:
            return .none
        }
    }
}
