//
//  TorrentsView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 13.08.2025.
//

import SwiftUI

struct TorrentsView: View {
    @StateObject @StateFlow var torrents: [Torrent]?
    let authRepository = AuthRepository()
    private let torrentRepository: TorrentRepository = .init()
    
    init(torrents: [Torrent]? = nil) {
        self._torrents = .init(wrappedValue: .init(value: torrents))
    }
    
    var body: some View {
        VStack {
            if let torrents {
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(torrents) { torrent in
                            TorrentItemView(torrent: torrent)
                        }
                    }
                    .padding()
                }
                .environment(torrentRepository)
            } else {
                Text("Пусто")
            }
        }
        .onAppear {
            _torrents.wrappedValue.setFetch {
                try await torrentRepository.getTorrentsInfo()
            }
        }
    }
}

#Preview {
    TorrentsView(torrents: .placeholder)
}
