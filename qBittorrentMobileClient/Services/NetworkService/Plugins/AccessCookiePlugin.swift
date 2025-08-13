import Foundation
import Moya

protocol AccessCookieProvider {
    var cookie: String? { get }
}

struct AccessCookiePlugin: PluginType {
    private let accessCookieProvider: AccessCookieProvider
    
    init(accessCookieProvider: AccessCookieProvider) {
        self.accessCookieProvider = accessCookieProvider
    }
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let mobileApiTarget = target as? MobileApiTargetType else {
            return request
        }
        
        return prepare(request, target: mobileApiTarget)
    }

    private func prepare(_ request: URLRequest, target: MobileApiTargetType) -> URLRequest {
        var request = request
        
//        if target.isAccessTokenRequired, let accessToken = accessCookieProvider.cookie {
//            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//        }
        
        return request
    }
}
