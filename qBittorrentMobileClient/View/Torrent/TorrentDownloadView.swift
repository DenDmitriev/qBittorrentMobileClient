//
//  TorrentDownloadView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 02.09.2025.
//

import SwiftUI

struct TorrentDownloadView: View {
    let state: TorrentState
    let progress: Double
    let size: Int
    let dlSpeed: Int
    let upSpeed: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .trailing) {
                ByteView(item: .size(size))
                
                if progress < 1 {
                    let remainingTime = remainingTime()
                    if remainingTime > 0, let remainingTimeString = DateComponentsFormatter.timeRemaingFormatter.string(from: remainingTime) {
                        HStack(spacing: 4) {
                            Text(remainingTimeString)
                                .font(.system(.body))
                            Image(systemName: "hourglass")
                                .foregroundStyle(.blue)
                        }
                    }
                }
            }
            
            VStack(alignment: .trailing) {
                switch state {
                case .downloading:
                    if progress < 1, dlSpeed > 0 {
                        ByteView(item: .speed(dlSpeed)) {
                            Image(systemName: "arrow.down")
                                .foregroundStyle(.green)
                        }
                    }
                    if upSpeed > 0 {
                        ByteView(item: .speed(upSpeed)) {
                            Image(systemName: "arrow.up")
                                .foregroundStyle(.blue)
                        }
                    }
                case .seeding:
                    if upSpeed > 0 {
                        ByteView(item: .speed(upSpeed)) {
                            Image(systemName: "arrow.up")
                                .foregroundStyle(.blue)
                        }
                    }
                case .pausedSeeding, .checking, .queued, .paused, .error, .missingFiles, .allocating, .moving, .unknown:
                    EmptyView()
                }
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
        }
    }
    
    var remainingSize: Int64 {
        Int64(Double(size) * (1.0 - progress))
    }
    
    func remainingTime() -> TimeInterval {
        guard dlSpeed > 0 else {
            return 0
        }
        
        return TimeInterval(remainingSize) / TimeInterval(dlSpeed)
    }
}

#Preview {
    TorrentDownloadView(state: .downloading, progress: 0.5, size: 37627101184, dlSpeed: 37627101, upSpeed: 176271)
}
