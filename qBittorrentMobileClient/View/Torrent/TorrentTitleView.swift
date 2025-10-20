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
        switch title {
        case .movie(let movie):
            ZStack {
                Text(movie.name)
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        case .series(let series):
            ZStack {
                Text(series.name)
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        case .other(let other):
            Text(other.original)
                .font(.headline)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        TorrentTitleView(title: .movie(.placeholder))
        TorrentTitleView(title: .series(.placeholder))
        TorrentTitleView(title: .other(.placeholder))
    }
}
