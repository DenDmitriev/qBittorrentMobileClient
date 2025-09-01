//
//  TorrentsView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 13.08.2025.
//

import SwiftUI

struct TorrentsView: View {
    @StateObject @StateFlow var torrents: [Torrent]?
    @Environment(TorrentRepository.self) private var torrentRepository
    @State private var isAddTorrentPresented = false
    
    init(torrents: [Torrent]? = nil) {
        self._torrents = .init(wrappedValue: .init(value: torrents))
    }
    
    var body: some View {
        VStack {
            if let torrents {
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(torrents) { torrent in
                            NavigationLink(value: Router.torrentContent(torrent: torrent)) {
                                TorrentItemView(torrent: torrent)
                            }
                            .tint(Color.primary)
                        }
                    }
                    .padding()
                }
            } else {
                Text("Пусто")
            }
        }
        .sheet(isPresented: $isAddTorrentPresented) {
            AddTorrentView()
        }
        .environment(torrentRepository)
        .navigationTitle(String(localized: "Torrents"))
        .toolbar {
            ToolbarItem(placement: .automatic) {
                ServerStatusIcon(error: $torrents.error)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(String(localized: "Add Torrent"), systemImage: "plus.circle.fill", action: showAddTorrentSheet)
            }
        }
        .onAppear {
            if _torrents.wrappedValue.wrappedValue == nil {
                _torrents.wrappedValue.setFetch {
                    try await torrentRepository.getTorrentsInfo()
                }
            } else {
                _torrents.wrappedValue.resumeFlow()
            }
        }
        .onDisappear {
            _torrents.wrappedValue.pauseFlow()
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
