//
//  TorrentCategoryView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 09.09.2025.
//

import SwiftUI

struct TorrentCategoryView: View {
    let category: TorrentCategory
    let torrents: [Torrent]
    
    @Binding var sort: TorrentSort
    @Binding var sortDirection: SortDirection
    
    var sortedTorrents: [Torrent] {
        let filtered = category == .all
        ? torrents
        : torrents.filter { $0.torrentCategory == category }
        
        return filtered.sorted { torrent1, torrent2 in
            let ascendingOrder: Bool
            switch sort {
            case .name:
                ascendingOrder = torrent1.name < torrent2.name
            case .size:
                ascendingOrder = torrent1.size < torrent2.size
            case .progress:
                ascendingOrder = torrent1.progress < torrent2.progress
            case .status:
                ascendingOrder = torrent1.state.rawValue < torrent2.state.rawValue
            case .addedOn:
                ascendingOrder = torrent1.addedOn < torrent2.addedOn
            }
            return sortDirection == .ascending ? ascendingOrder : !ascendingOrder
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(sortedTorrents) { torrent in
                    NavigationLink(value: Router.torrentContent(torrent: torrent)) {
                        TorrentItemView(torrent: torrent)
                    }
                    .tint(Color.primary)
                }
            }
            .padding()
        }
        .background(Color.backgroundSecond)
    }
}

#Preview {
    NavigationStack {
        TorrentCategoryView(
            category: .all,
            torrents: .placeholder,
            sort: .constant(.size),
            sortDirection: .constant(.ascending)
        )
    }
    .environment(TorrentRepository())
}
