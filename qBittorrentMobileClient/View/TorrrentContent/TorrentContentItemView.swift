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
        HStack {
            ContentIconView(contentType: content.contentType)
                .padding(12)
                .frame(width: 60)
            
            VStack(alignment: .leading) {
                Text(content.name.components(separatedBy: "/").last ?? content.name)
                    .font(.system(size: 12))
                    .lineLimit(2)
                HStack {
                    HStack(spacing: .zero) {
                        Image(systemName: "document")
                        ByteView(item: .size(Int(content.size)))
                    }
                    
                    HStack(spacing: .zero) {
                        Image(systemName: "hourglass")
                        ByteView(item: .size(Int(content.remainingSize)))
                    }
                }
                .font(.caption.weight(.medium))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            PriorityButton(progress: content.progress, priority: content.priority) { newPriority in
                setPriority(newPriority)
            }
        }
        .frame(height: 60)
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
    .environment(TorrentRepository())
}
