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
    @StateFlow private var contents: [TorrentContent]?
    
    init(torrent: Torrent) {
        self.torrent = torrent
        self._contents = .init(value: nil)
    }
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                if let contents {
                    LazyVStack {
                        ForEach(contents) { content in
                            TorrentContentItemView(torrent: torrent, content: content)
                        }
                    }
                    .padding()
                }
            }
            .background(Color.backgroundSecond)
        }
        .stateFlow(
            _contents.phase,
            loadingContent: { SkeletonContentView(height: 137) },
            emptyContent: { EmptyContentView(retry: { _contents.retry() }) },
            failureContent: { FailureContentView(error: $0, retry: { _contents.retry() }) }
        )
        .navigationTitle(String(localized: "Torrent Content"))
        .onAppear {
            _contents.setFetch {
                try await torrentRepository.getTorrentContent(id: torrent.id)
            }
        }
        .onDisappear {
            _contents.invalidate()
        }
    }
}

#Preview {
    TorrentContentView(torrent: .placeholder)
        .environment(TorrentRepository())
}
