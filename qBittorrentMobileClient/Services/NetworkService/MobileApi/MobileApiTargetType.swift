import Foundation
import Moya

protocol MobileApiTargetType: TargetType, AccessTokenAuthorizable {
    var formData: [MultipartFormData] { get }
}
