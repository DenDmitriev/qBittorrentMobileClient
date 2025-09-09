//
//  TorrentsView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 13.08.2025.
//

import SwiftUI

struct TorrentsView: View {
    @StateFlow var torrents: [Torrent]?
    @Environment(TorrentRepository.self) private var torrentRepository
    @State private var isAddTorrentPresented = false
    
    init(torrents: [Torrent]? = nil) {
        self._torrents = .init(value: torrents)
    }
    
    var body: some View {
        ScrollView {
            if let torrents {
                LazyVStack {
                    ForEach(torrents) { torrent in
                        NavigationLink(value: Router.torrentContent(torrent: torrent)) {
                            TorrentItemView(torrent: torrent)
                        }
                        .tint(Color.primary)
                    }
                }
                .padding()
            }
        }
        .background(Color.backgroundSecond)
        .stateFlow(
            _torrents.phase,
            loadingContent: { SkeletonContentView(height: 120) },
            emptyContent: { EmptyContentView(retry: { _torrents.retry() }) },
            failureContent: { FailureContentView(error: $0, retry: { _torrents.retry() }) }
        )
        .sheet(isPresented: $isAddTorrentPresented) {
            AddTorrentView()
        }
        .environment(torrentRepository)
        .navigationTitle(String(localized: "Torrents"))
        .toolbar {
            ToolbarItem(placement: .automatic) {
                ServerStatusIcon(error: _torrents.error)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(String(localized: "Add Torrent"), systemImage: "plus.circle.fill", action: showAddTorrentSheet)
            }
        }
        .onAppear {
            _torrents.setFetch {
                try await torrentRepository.getTorrentsInfo()
            }
        }
        .onDisappear {
            _torrents.invalidate()
        }
    }
    
    private func showAddTorrentSheet() {
        isAddTorrentPresented = true
    }
}

#Preview {
    NavigationStack {
        TorrentsView(torrents: .placeholder)
    }
    .environment(TorrentRepository())
}
