//
//  TorrentContentView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 28.08.2025.
//

import SwiftUI

struct TorrentContentView: View {
    let torrent: Torrent

    @Environment(TorrentRepository.self) private var torrentRepository
    @StateObject @StateFlow private var contents: [TorrentContent]?
    
    init(torrent: Torrent) {
        self.torrent = torrent
        self._contents = .init(wrappedValue: .init(value: nil))
    }
    
    var body: some View {
        VStack {
            if let contents {
                ScrollView(.vertical) {
                    LazyVStack {
                        ForEach(contents) { content in
                            TorrentContentItemView(torrent: torrent, content: content)
                        }
                    }
                }
            } else {
                if let error = _contents.wrappedValue.error {
                    Text((error as? ServerError)?.details.message ?? "Error")
                } else {
                    Text("Пусто")
                }
            }
        }
        .onAppear {
            if _contents.wrappedValue.wrappedValue == nil {
                _contents.wrappedValue.setFetch {
                    try await torrentRepository.getTorrentContent(id: torrent.id)
                }
            } else {
                _contents.wrappedValue.resumeFlow()
            }
        }
        .onDisappear {
            _contents.wrappedValue.pauseFlow()
        }
    }
}

#Preview {
    TorrentContentView(torrent: .placeholder)
        .environment(TorrentRepository())
}
