//
//  TorrentRepository.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 13.08.2025.
//

import Foundation

@Observable
class TorrentRepository {
    private var mobileService = MobileService.shared
    
    func getTorrentsInfo() async throws -> [Torrent] {
        return try await mobileService.request(target: .torrent(.getTorrentsInfo))
    }
    
    func pauseTorrent(id: Torrent.ID) async throws {
        try await mobileService.request(target: .torrent(.pause(id: id)))
    }
    
    func resumeTorrent(id: Torrent.ID) async throws {
        try await mobileService.request(target: .torrent(.resume(id: id)))
    }
    
    func forceStartTorrent(id: Torrent.ID) async throws {
        try await mobileService.request(target: .torrent(.forceStart(id: id)))
    }
    
    func recheckTorrent(id: Torrent.ID) async throws {
        try await mobileService.request(target: .torrent(.recheck(id: id)))
    }
    
    func getTorrentContent(id: Torrent.ID) async throws -> [TorrentContent] {
        return try await mobileService.request(target: .torrent(.getTorrentContents(id: id)))
    }
    
    func addTorrent(url: URL, paused: Bool, loadSequentially: Bool) async throws {
        try await mobileService.request(target: .torrent(.addTorrent(url: url, paused: paused, loadSequentially: loadSequentially)))
    }
    
    func addTorrent(file: URL, paused: Bool, loadSequentially: Bool) async throws {
        try await mobileService.request(target: .torrent(.addTorrentFile(url: file, paused: paused, loadSequentially: loadSequentially)))
    }
    
    func setFilePriority(torrentId: Torrent.ID, fileId: TorrentContent.ID, priority: TorrentPriority) async throws {
        try await mobileService.request(target: .torrent(.setFilePriority(torrentId: torrentId, fileId: fileId, priority: priority)))
    }
}
