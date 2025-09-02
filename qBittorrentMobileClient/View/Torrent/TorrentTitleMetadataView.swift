//
//  TorrentTitleMetadataView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 02.09.2025.
//

import SwiftUI

struct TorrentTitleMetadataView: View {
    let title: TorrentTitle
    
    var body: some View {
        Group {
            switch title {
            case .movie(let movie):
                VStack(alignment: .leading) {
                    if let format = movie.format {
                        VideoFormatView(format: format)
                    }
                }
            case .series(let series):
                VStack(alignment: .leading) {
                    SessionEpisodeView(session: series.session, episode: series.episode)
                    if let format = series.format {
                        VideoFormatView(format: format)
                    }
                }
            case .other:
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    VStack(spacing: 20) {
        TorrentTitleMetadataView(title: .movie(.placeholder))
        TorrentTitleMetadataView(title: .series(.placeholder))
        TorrentTitleMetadataView(title: .other(.placeholder))
    }
}
