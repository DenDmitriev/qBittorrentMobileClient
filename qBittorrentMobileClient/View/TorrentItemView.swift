//
//  TorrentItemView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 14.08.2025.
//

import SwiftUI

struct TorrentItemView: View {
    let torrent: Torrent
    
    var body: some View {
        Text(torrent.name)
            .lineLimit(1)
    }
}

#Preview {
    TorrentItemView(torrent: .placeholder)
}
