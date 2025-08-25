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
    case pause(id: Torrent.ID)
    case resume(id: Torrent.ID)
    case forceStart(id: Torrent.ID)
    case recheck(id: Torrent.ID)
}

extension TorrentApi: MobileApiTargetType {
    var baseURL: URL { getBaseURL() }
    var path: String { getPath() }
    var method: Moya.Method { getMethod() }
    var task: Moya.Task { getTask() }
    var formData: [MultipartFormData] { getFormData() }
    var headers: [String: String]? { getHeaders() }
    
    private func getBaseURL() -> URL { URL(string: "http://192.168.31.33:8080")! }
//    private func getBaseURL() -> URL { URL(string: "http://10.147.20.215:8080")! }
    
    private func getPath() -> String {
        switch self {
        case .getTorrentsInfo:
            return "/api/v2/torrents/info"
        case .pause(let id):
            return "/api/v2/torrents/pause"
        case .resume(let id):
            return "/api/v2/torrents/resume"
        case .forceStart(let id):
            return "/api/v2/torrents/setForceStart"
        case .recheck(let id):
            return "/api/v2/torrents/recheck"
        }
    }
    
    private func getMethod() -> Moya.Method {
        switch self {
        case .getTorrentsInfo:
            return .get
        case .pause, .resume, .forceStart, .recheck:
            return .post
        }
    }
    
    private func getTask() -> Moya.Task {
        switch self {
        case .getTorrentsInfo:
            return .requestPlain
        case .pause, .resume, .forceStart, .recheck:
            return .uploadMultipart(formData)
        }
    }
    
    private func getFormData() -> [MultipartFormData] {
        var multipartData = [MultipartFormData]()
        
        switch self {
        case .getTorrentsInfo:
            break
        case .pause(let id), .resume(let id), .recheck(let id):
            multipartData.append(MultipartFormData(provider: .data(id.data(using: .utf8)!), name: "hashes"))
        case .forceStart(let id):
            multipartData.append(contentsOf: [
                MultipartFormData(provider: .data(id.data(using: .utf8)!), name: "hashes"),
                MultipartFormData(provider: .data(String("value").data(using: .utf8)!), name: "value")
            ])
        }
        
        return multipartData
    }
    
    private func getHeaders() -> [String: String]? {
        switch self {
        case .getTorrentsInfo, .pause, .resume, .recheck, .forceStart:
            return [:]
        }
    }
}
