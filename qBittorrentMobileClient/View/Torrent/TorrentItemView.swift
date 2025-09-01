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
                TorrentTitleView(title: TorrentNameParser.parseTorrentName(torrent.name))
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    HStack(spacing: .zero) {
                        Image(systemName: "document")
                        ByteView(item: .size(Int(torrent.size)))
                    }
                    HStack(spacing: .zero) {
                        Image(systemName: "arrow.down")
                            .foregroundStyle(.green)
                        ByteView(item: .speed(torrent.dlspeed))
                    }
                    HStack(spacing: .zero) {
                        Image(systemName: "arrow.up")
                            .foregroundStyle(.blue)
                        ByteView(item: .speed(torrent.upspeed))
                    }
                    
                    let remainingTime = torrent.remainingTime(dlspeed: torrent.dlspeed)
                    if remainingTime > 0, let remainingTimeString = DateComponentsFormatter.timeRemaingFormatter.string(from: remainingTime) {
                        HStack(spacing: .zero) {
                            Image(systemName: "clock")
                            Text(remainingTimeString)
                        }
                    }
                }
                .font(.caption.weight(.medium))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            DownloadButton(progress: torrent.progress, state: torrent.state) { action in
                handleAction(action: action)
            }
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
            }
        }
    }
}

#Preview {
    TorrentItemView(torrent: .placeholder)
        .environment(TorrentRepository())
        .padding()
}
