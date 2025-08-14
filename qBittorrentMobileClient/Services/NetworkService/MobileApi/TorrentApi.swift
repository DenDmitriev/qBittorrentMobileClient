//
//  TorrentApi.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 13.08.2025.
//

import Foundation
import Moya

enum TorrentApi {
    case getTorrentsInfo
}

extension TorrentApi: MobileApiTargetType {
    var baseURL: URL { getBaseURL() }
    var path: String { getPath() }
    var method: Moya.Method { getMethod() }
    var task: Moya.Task { getTask() }
    var formData: [MultipartFormData] { getFormData() }
    var headers: [String: String]? { getHeaders() }
    
    private func getBaseURL() -> URL { URL(string: "http://192.168.31.33:8080")! }
    
    private func getPath() -> String {
        switch self {
        case .getTorrentsInfo:
            return "/api/v2/torrents/info"
        }
    }
    
    private func getMethod() -> Moya.Method {
        switch self {
        case .getTorrentsInfo:
            return .get
        }
    }
    
    private func getTask() -> Moya.Task {
        switch self {
        case .getTorrentsInfo:
            return .requestPlain
        }
    }
    
    private func getFormData() -> [MultipartFormData] {
        var multipartData = [MultipartFormData]()
        
        switch self {
        case .getTorrentsInfo:
            break
        }
        
        return multipartData
    }
    
    private func getHeaders() -> [String: String]? {
        switch self {
        case .getTorrentsInfo:
            return [:]
        }
    }
}
