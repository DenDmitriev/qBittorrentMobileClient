//
//  Router.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 25.08.2025.
//

import SwiftUI

enum Router: Hashable {
    case torrents
    case accountSettings
    case torrentSettings
    
    @ViewBuilder static func destination(route: Router) -> some View {
        switch route {
        case .torrents:
            TorrentsView()
        case .accountSettings:
            AccountSettingsView()
        case .torrentSettings:
            TorrentSettingsView()
        }
    }
}
