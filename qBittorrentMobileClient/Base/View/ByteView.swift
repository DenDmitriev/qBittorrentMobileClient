//
//  ByteView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 19.08.2025.
//

import SwiftUI

struct ByteView: View {
    let bytes: Int64
    static var formatter: ByteCountFormatter = {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useBytes, .useKB, .useMB, .useGB, .useTB, .usePB]
        formatter.countStyle = .file // Используется для файловых размеров (1 KB = 1024 bytes)
        return formatter
    }()
    
    var body: some View {
        Text(Self.formatter.string(fromByteCount: bytes))
    }
}

#Preview {
    VStack {
        ByteView(bytes: 37627101184) // ~35 GB
        ByteView(bytes: 1024) // 1 KB
        ByteView(bytes: 1536) // 1.5 KB
        ByteView(bytes: 1234567) // 1.2 MB
        ByteView(bytes: 1234567890123) // 1.1 TB
    }
}
