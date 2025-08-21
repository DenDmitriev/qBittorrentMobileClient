//
//  TorrentItemView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 14.08.2025.
//

import SwiftUI

struct TorrentItemView: View {
    let torrent: Torrent
    @Environment(TorrentRepository.self) private var torrentRepository
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(torrent.name)
                    .font(.system(size: 12))
                    .lineLimit(2)
                ByteView(bytes: torrent.size)
                    .font(.caption.weight(.medium))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            DownloadButton(progress: torrent.progress, state: torrent.state) { action in
                handleAction(action: action)
            }
        }
        .animation(.easeInOut(duration: 1), value: torrent.progress)
    }
    
    private func handleAction(action: TorrentAction) {
        Task {
            switch action {
            case .pause:
                try await torrentRepository.pauseTorrent(id: torrent.id)
            case .resume:
                try await torrentRepository.resumeTorrent(id: torrent.id)
            case .forceStart:
                try await torrentRepository.forceStartTorrent(id: torrent.id)
            case .recheck:
                try await torrentRepository.recheckTorrent(id: torrent.id)
            }
        }
    }
}

#Preview {
    TorrentItemView(torrent: .placeholder)
        .environment(TorrentRepository())
        .padding()
}
