//
//  TorrentRepository.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 13.08.2025.
//

import Foundation

class TorrentRepository {
    private lazy var mobileService = MobileService.shared
    
    func getTorrentsInfo() async throws -> [Torrent] {
        return try await mobileService.request(target: .torrent(.getTorrentsInfo))
    }
}
