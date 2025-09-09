//
//  SortDirection.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 09.09.2025.
//

import Foundation

enum SortDirection: String, CaseIterable, Identifiable {
    case ascending
    case descending
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .ascending:
            return String(localized: "Ascending")
        case .descending:
            return String(localized: "Descending")
        }
    }
    
    var systemImage: String {
        switch self {
        case .ascending:
            return "arrow.up.circle"
        case .descending:
            return "arrow.down.circle"
        }
    }
    
    var selectedSystemImage: String {
        switch self {
        case .ascending:
            return "arrow.up.circle.fill"
        case .descending:
            return "arrow.down.circle.fill"
        }
    }
}
