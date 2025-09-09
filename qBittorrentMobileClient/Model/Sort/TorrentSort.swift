//
//  TorrentSort.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 09.09.2025.
//

import Foundation

enum TorrentSort: String, CaseIterable, Identifiable {
    case name
    case size
    case progress
    case status
    case addedOn
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .name:
            return String(localized: "Name")
        case .size:
            return String(localized: "Size")
        case .progress:
            return String(localized: "Progress")
        case .status:
            return String(localized: "Status")
        case .addedOn:
            return String(localized: "Date Added")
        }
    }
}
