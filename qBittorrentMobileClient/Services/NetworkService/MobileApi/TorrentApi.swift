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
    case delete(id: Torrent.ID, deleteFiles: Bool)
    case getTorrentContents(id: Torrent.ID)
    case getTorrentProperties(id: Torrent.ID)
    case addTorrent(url: URL, paused: Bool, loadSequentially: Bool, dlLimit: Int?, upLimit: Int?)
    case addTorrentFile(url: URL, paused: Bool, loadSequentially: Bool, dlLimit: Int?, upLimit: Int?)
    case setFilePriority(torrentId: Torrent.ID, fileId: TorrentContent.ID, priority: TorrentPriority)
    case setDownloadLimit(torrentId: Torrent.ID, limit: Int)
    case setUploadLimit(torrentId: Torrent.ID, limit: Int)
}

extension TorrentApi: MobileApiTargetType, TorrentServer {
    var baseURL: URL { serverURL }
    var path: String { getPath() }
    var method: Moya.Method { getMethod() }
    var task: Moya.Task { getTask() }
    var formData: [MultipartFormData] { getFormData() }
    var headers: [String: String]? { getHeaders() }
    var parameters: [String: Any] { getParameters() }
    
    private func getPath() -> String {
        switch self {
        case .getTorrentsInfo:
            return "/api/v2/torrents/info"
        case .getTorrentContents:
            return "/api/v2/torrents/files"
        case .getTorrentProperties:
            return "/api/v2/torrents/properties"
        case .pause:
            return "/api/v2/torrents/pause"
        case .resume:
            return "/api/v2/torrents/resume"
        case .forceStart:
            return "/api/v2/torrents/setForceStart"
        case .recheck:
            return "/api/v2/torrents/recheck"
        case .delete:
            return "/api/v2/torrents/delete"
        case .addTorrent, .addTorrentFile:
            return "/api/v2/torrents/add"
        case .setFilePriority:
            return "/api/v2/torrents/filePrio"
        case .setDownloadLimit:
            return "/api/v2/torrents/setDownloadLimit"
        case .setUploadLimit:
            return "/api/v2/torrents/setUploadLimit"
        }
    }
    
    private func getMethod() -> Moya.Method {
        switch self {
        case .getTorrentsInfo, .getTorrentProperties:
            return .get
        case .getTorrentContents, .pause, .resume, .forceStart, .recheck, .delete, .addTorrent, .addTorrentFile, .setFilePriority, .setDownloadLimit, .setUploadLimit:
            return .post
        }
    }
    
    private func getTask() -> Moya.Task {
        switch self {
        case .getTorrentsInfo:
            return .requestPlain
        case .getTorrentProperties:
            let encoding = URLEncoding(destination: .queryString, arrayEncoding: .noBrackets, boolEncoding: .literal)
            return .requestParameters(parameters: parameters, encoding: encoding)
        case .pause, .resume, .forceStart, .recheck, .delete, .addTorrent, .addTorrentFile, .getTorrentContents, .setFilePriority, .setDownloadLimit, .setUploadLimit:
            return .uploadMultipart(formData)
        }
    }
    
    private func getParameters() -> [String: Any] {
        var parameters = [String: Any]()
        
        switch self {
        case .getTorrentProperties(let id):
            parameters["hash"] = id
        case .getTorrentsInfo, .pause, .resume, .forceStart, .recheck, .delete, .getTorrentContents, .addTorrent, .addTorrentFile, .setFilePriority, .setDownloadLimit, .setUploadLimit:
            break
        }
        
        return parameters
    }
    
    private func getFormData() -> [MultipartFormData] {
        var multipartData = [MultipartFormData]()
        
        switch self {
        case .getTorrentsInfo:
            break
        case .pause(let id), .resume(let id), .recheck(let id):
            multipartData.append(MultipartFormData(provider: .data(id.data(using: .utf8)!), name: "hashes"))
        case let .delete(id, deleteFiles):
            multipartData.append(contentsOf: [
                MultipartFormData(provider: .data(id.data(using: .utf8)!), name: "hashes"),
                MultipartFormData(provider: .data(String(deleteFiles).data(using: .utf8)!), name: "deleteFiles")
            ])
        case .forceStart(let id):
            multipartData.append(contentsOf: [
                MultipartFormData(provider: .data(id.data(using: .utf8)!), name: "hashes"),
                MultipartFormData(provider: .data(String("true").data(using: .utf8)!), name: "value")
            ])
        case .getTorrentContents(let id):
            multipartData.append(MultipartFormData(provider: .data(id.data(using: .utf8)!), name: "hash"))
        case .getTorrentProperties:
            break
        case let .addTorrent(url, paused, loadSequentially, dlLimit, upLimit):
            multipartData.append(contentsOf: [
                MultipartFormData(provider: .data(url.absoluteString.data(using: .utf8)!), name: "urls"),
                MultipartFormData(provider: .data(String(paused).data(using: .utf8)!), name: "paused"),
                MultipartFormData(provider: .data(String(loadSequentially).data(using: .utf8)!), name: "sequentialDownload")
            ])
            if let dlLimit {
                multipartData.append(MultipartFormData(provider: .data(String(dlLimit).data(using: .utf8)!), name: "dlLimit"))
            }
            if let upLimit {
                multipartData.append(MultipartFormData(provider: .data(String(upLimit).data(using: .utf8)!), name: "upLimit"))
            }
        case let .addTorrentFile(url, paused, loadSequentially, dlLimit, upLimit):
            multipartData.append(contentsOf: [
                MultipartFormData(provider: .file(url), name: "torrents", fileName: url.lastPathComponent, mimeType: "application/x-bittorrent"),
                MultipartFormData(provider: .data(String(paused).data(using: .utf8)!), name: "paused"),
                MultipartFormData(provider: .data(String(loadSequentially).data(using: .utf8)!), name: "sequentialDownload")
            ])
            if let dlLimit {
                multipartData.append(MultipartFormData(provider: .data(String(dlLimit).data(using: .utf8)!), name: "dlLimit"))
            }
            if let upLimit {
                multipartData.append(MultipartFormData(provider: .data(String(upLimit).data(using: .utf8)!), name: "upLimit"))
            }
        case let .setFilePriority(torrentId, fileId,  priority):
            multipartData.append(contentsOf: [
                MultipartFormData(provider: .data(torrentId.data(using: .utf8)!), name: "hash"),
                MultipartFormData(provider: .data(String(fileId).data(using: .utf8)!), name: "id"),
                MultipartFormData(provider: .data(String(priority.rawValue).data(using: .utf8)!), name: "priority")
            ])
        case let .setDownloadLimit(torrentId, limit):
            multipartData.append(contentsOf: [
                MultipartFormData(provider: .data(torrentId.data(using: .utf8)!), name: "hashes"),
                MultipartFormData(provider: .data(String(limit).data(using: .utf8)!), name: "limit"),
            ])
        case let .setUploadLimit(torrentId, limit):
            multipartData.append(contentsOf: [
                MultipartFormData(provider: .data(torrentId.data(using: .utf8)!), name: "hashes"),
                MultipartFormData(provider: .data(String(limit).data(using: .utf8)!), name: "limit"),
            ])
        }
        
        return multipartData
    }
    
    private func getHeaders() -> [String: String]? {
        return nil
    }
}
