//
//  ConnectTestView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 13.08.2025.
//

import SwiftUI

struct ConnectTestView: View {
    @StateObject @StateFlow var torrents: [Torrent]?
    let authRepository = AuthRepository()
    let torrentRepository = TorrentRepository()
    
    init() {
        self._torrents = .init(wrappedValue: .init())
    }
    
    var body: some View {
        VStack {
            if let torrents {
                ScrollView {
                    LazyVStack {
                        ForEach(torrents) { torrent in
                            TorrentItemView(torrent: torrent)
                        }
                    }
                }
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
    ConnectTestView()
}
