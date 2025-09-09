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
    let dlspeed: Int
    let upspeed: Int
    
    var body: some View {
        VStack(alignment: .trailing) {
            ByteView(item: .size(size))
            
            switch state {
            case .downloading:
                if progress < 1, dlspeed > 0 {
                    ByteView(item: .speed(dlspeed)) {
                        Image(systemName: "arrow.down")
                            .foregroundStyle(.green)
                    }
                }
                if upspeed > 0 {
                    ByteView(item: .speed(upspeed)) {
                        Image(systemName: "arrow.up")
                            .foregroundStyle(.blue)
                    }
                }
            case .seeding:
                if upspeed > 0 {
                    ByteView(item: .speed(upspeed)) {
                        Image(systemName: "arrow.up")
                            .foregroundStyle(.blue)
                    }
                }
            case .pausedSeeding, .checking, .queued, .paused, .error, .missingFiles, .allocating, .moving, .unknown:
                EmptyView()
            }
            
            if progress < 1 {
                let remainingTime = remainingTime()
                if remainingTime > 0, let remainingTimeString = DateComponentsFormatter.timeRemaingFormatter.string(from: remainingTime) {
                    HStack(spacing: .zero) {
                        Image(systemName: "hourglass")
                            .foregroundStyle(.blue)
                        Text(remainingTimeString)
                            .font(.system(.body))
                    }
                }
            }
        }
    }
    
    var remainingSize: Int64 {
        Int64(Double(size) * (1.0 - progress))
    }
    
    func remainingTime() -> TimeInterval {
        guard dlspeed > 0 else {
            return 0
        }
        
        return TimeInterval(remainingSize) / TimeInterval(dlspeed)
    }
}

#Preview {
    TorrentDownloadView(state: .downloading, progress: 0.5, size: 37627101184, dlspeed: 37627101, upspeed: 176271)
}
