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
    case addTorrent(url: URL, paused: Bool, loadSequentially: Bool, dlLimit: Int?, upLimit: Int?)
    case addTorrentFile(url: URL, paused: Bool, loadSequentially: Bool, dlLimit: Int?, upLimit: Int?)
    case setFilePriority(torrentId: Torrent.ID, fileId: TorrentContent.ID, priority: TorrentPriority)
}

extension TorrentApi: MobileApiTargetType, TorrentServer {
    var baseURL: URL { serverURL }
    var path: String { getPath() }
    var method: Moya.Method { getMethod() }
    var task: Moya.Task { getTask() }
    var formData: [MultipartFormData] { getFormData() }
    var headers: [String: String]? { getHeaders() }
    
    private func getPath() -> String {
        switch self {
        case .getTorrentsInfo:
            return "/api/v2/torrents/info"
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
        case .getTorrentContents:
            return "/api/v2/torrents/files"
        case .addTorrent, .addTorrentFile:
            return "/api/v2/torrents/add"
        case .setFilePriority:
            return "/api/v2/torrents/filePrio"
        }
    }
    
    private func getMethod() -> Moya.Method {
        switch self {
        case .getTorrentsInfo:
            return .get
        case .pause, .resume, .forceStart, .recheck, .delete, .addTorrent, .addTorrentFile, .getTorrentContents, .setFilePriority:
            return .post
        }
    }
    
    private func getTask() -> Moya.Task {
        switch self {
        case .getTorrentsInfo:
            return .requestPlain
        case .pause, .resume, .forceStart, .recheck, .delete, .addTorrent, .addTorrentFile, .getTorrentContents, .setFilePriority:
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
        }
        
        return multipartData
    }
    
    private func getHeaders() -> [String: String]? {
        return nil
    }
}
