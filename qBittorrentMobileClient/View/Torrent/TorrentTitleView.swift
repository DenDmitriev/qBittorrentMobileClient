//
//  TorrentTitleView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 01.09.2025.
//

import SwiftUI

struct TorrentTitleView: View {
    let title: TorrentTitle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.name)
                .font(.headline)
                .lineLimit(2)
            HStack {
                if let season = title.season {
                    Text("Session \(season)")
                }
                if let episode = title.episode {
                    Text("Episode \(episode)")
                }
            }
            .font(.subheadline)
            .foregroundColor(.gray)
            HStack {
                if let format = title.format {
                    Text(format)
                }
                
                if let year = title.year {
                    Text(year)
                }
            }
            .font(.subheadline)
            .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    TorrentTitleView(
        title: TorrentTitle(name: "The Little Drummer Girl", season: 1, episode: 5, format: "1080p", year: "2025", original: "The Little Drummer Girl 1 - LostFilm.TV [1080p]")
    )
}
