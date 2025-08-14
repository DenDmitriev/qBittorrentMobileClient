import Foundation
import Moya

protocol MobileApiTargetType: TargetType {
    var formData: [MultipartFormData] { get }
}
