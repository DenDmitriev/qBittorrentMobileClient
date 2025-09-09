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
    @AppStorage(AppStorageKeys.torrentSettingDeleteFiles) private var deleteFiles = true
    
    var body: some View {
        VStack(alignment: .leading) {
            TorrentTitleView(title: torrent.title)
            HStack(alignment: .bottom) {
                TorrentTitleMetadataView(title: torrent.title)
                TorrentDownloadView(
                    state: torrent.state,
                    progress: torrent.progress,
                    size: Int(torrent.size),
                    dlspeed: torrent.dlspeed,
                    upspeed: torrent.upspeed
                )
                Spacer(minLength: 12)
                DownloadButton(progress: torrent.progress, state: torrent.state) { action in
                    handleAction(action: action)
                }
            }
        }
        .padding(12)
        .background(Color.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .contextMenu {
            Button("Resume", systemImage: "play", action: { handleAction(action: .resume) } )
            Button("Force Start", systemImage: "forward", action: { handleAction(action: .forceStart) } )
            Button("Recheck", systemImage: "arrow.triangle.2.circlepath", action: { handleAction(action: .recheck) } )
            Button("Delete", systemImage: "trash", role: .destructive, action: { handleAction(action: .delete) } )
        }
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
            case .delete:
                try await torrentRepository.deleteTorrent(id: torrent.id, deleteFiles: deleteFiles)
            }
        }
    }
}

#Preview {
    TorrentItemView(torrent: .placeholder)
        .environment(TorrentRepository())
        .padding()
        .background(Color.backgroundSecond)
}
