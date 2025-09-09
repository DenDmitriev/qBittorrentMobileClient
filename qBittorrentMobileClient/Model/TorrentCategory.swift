//
//  TorrentCategory.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 09.09.2025.
//

import Foundation

enum TorrentCategory: String, CaseIterable, Identifiable, Titleable {
    case all, downloading, downloaded, paused, seeding, error
    
    var id: Self { self }
    
    var index: Int {
        switch self {
        case .all:
            0
        case .downloading:
            1
        case .downloaded:
            2
        case .paused:
            3
        case .seeding:
            4
        case .error:
            10
        }
    }
    
    var title: String {
        switch self {
        case .all:
            return String(localized: "All")
        case .downloading:
            return String(localized: "Downloading")
        case .seeding:
            return String(localized: "Seeding")
        case .downloaded:
            return String(localized: "Downloaded")
        case .paused:
            return String(localized: "Paused")
        case .error:
            return String(localized: "Error")
        }
    }
}

extension TorrentCategory {
    init(state: TorrentState) {
        switch state {
        case .downloading:
            self = .downloading
        case .paused:
            self = .paused
        case .queued:
            self = .paused
        case .checking:
            self = .downloading
        case .seeding:
            self = .seeding
        case .pausedSeeding:
            self = .paused
        case .error:
            self = .error
        case .missingFiles:
            self = .error
        case .allocating:
            self = .paused
        case .moving:
            self = .paused
        case .unknown:
            self = .error
        }
    }
}
