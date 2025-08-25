//
//  Tab.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 25.08.2025.
//

import Foundation

enum TabItem: Hashable, CaseIterable, Identifiable {
    case main
    case settings
    
    var id: String { title }
    
    var title: String {
        switch self {
        case .main:
            return "Torrents"
        case .settings:
            return "Settings"
        }
    }
}
