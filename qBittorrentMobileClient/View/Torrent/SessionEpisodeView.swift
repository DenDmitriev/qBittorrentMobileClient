//
//  SessionEpisodeView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 02.09.2025.
//

import SwiftUI

struct SessionEpisodeView: View {
    let session: Int?
    let episode: Int?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let session {
                HStack(spacing: 0) {
                    Text("Session")
                        .font(.caption)
                    Text(session.formatted())
                        .font(.headline.bold())
                }
            }
            if let episode {
                HStack(spacing: 0) {
                    Text("Episode")
                        .font(.caption)
                    Text(episode.formatted())
                        .font(.headline.bold())
                }
            }
        }
        .foregroundStyle(.secondary)
    }
}

#Preview {
    VStack(spacing: 20) {
        SessionEpisodeView(session: 3, episode: 15)
        SessionEpisodeView(session: 1, episode: nil)
        SessionEpisodeView(session: nil, episode: 7)
    }
}
