//
//  TorrentContentItemView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 28.08.2025.
//

import SwiftUI

struct TorrentContentItemView: View {
    let torrent: Torrent
    let content: TorrentContent
    
    @Environment(TorrentRepository.self) private var torrentRepository
    
    var body: some View {
        VStack {
            HStack {
                ContentIconView(contentType: content.contentType)
                    .frame(width: 30)
                    .foregroundStyle(.secondary)
                Text(content.lastComponentName)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            HStack(alignment: .bottom, spacing: 12) {
                if content.contentType.type == .video {
                    TorrentTitleMetadataView(title: content.title)
                }
                ByteView(item: .size(Int(content.size)))
                PriorityButton(progress: content.progress, priority: content.priority) { newPriority in
                    setPriority(newPriority)
                }
                .frame(height: 60)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(12)
        .background(Color.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private func setPriority(_ priority: TorrentPriority) {
        guard priority != content.priority else {
            return
        }
        
        Task {
            try await torrentRepository.setFilePriority(torrentId: torrent.id, fileId: content.id, priority: priority)
        }
    }
}

#Preview {
    VStack {
        TorrentContentItemView(torrent: .placeholder, content: .movie)
        TorrentContentItemView(torrent: .placeholder, content: .audio)
        TorrentContentItemView(torrent: .placeholder, content: .subtitle)
        TorrentContentItemView(torrent: .placeholder, content: .file)
    }
    .padding()
    .background(Color.backgroundSecond)
    .environment(TorrentRepository())
}
