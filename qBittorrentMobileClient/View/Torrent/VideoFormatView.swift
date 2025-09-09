//
//  VideoFormatView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 02.09.2025.
//

import SwiftUI

struct VideoFormatView: View {
    let format: String
    
    var body: some View {
        Text(format)
            .font(.caption.weight(.bold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(RoundedRectangle(cornerRadius: 4).stroke(lineWidth: 1))
            .foregroundStyle(.secondary)
    }
}

#Preview {
    let foramts = ["1080p", "720p", "2160p", "4K", "2K", "BluRay", "WEB-DL", "WEBRip", "HDRip", "DVDRip", "HDTV", "SDTV"]
    VStack {
        ForEach(foramts, id: \.self) { format in
            VideoFormatView(format: format)
        }
    }
}
