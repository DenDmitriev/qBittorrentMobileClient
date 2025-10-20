//
//  TorrentPropertiesView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 12.09.2025.
//

import SwiftUI

enum TorrentPropertiesTab: String, CaseIterable, Identifiable, Titleable {
    case main
    case torrent
    case limits
    
    var title: String {
        switch self {
        case .main:
            String(localized: "Main")
        case .torrent:
            String(localized: "Torrent")
        case .limits:
            String(localized: "Limits")
        }
    }
    
    var id: Self { self }
}

struct TorrentPropertiesView: View {
    let torrent: Torrent
    @Binding var selected: TorrentPropertiesTab.ID?
    
    @Environment(TorrentRepository.self) private var torrentRepository
    @StateFlow private var properties: TorrentGenericProperties?
    @State private var tabs: [TorrentPropertiesTab] = [.main, .torrent, .limits]
    
    var body: some View {
        VStack {
            if let properties {
                PageView(selected: $selected, pages: $tabs) {
                    ForEach(tabs) { tab in
                        switch tab {
                        case .main:
                            TorrentPropertiesMainView(properties: properties)
                                .tag(tab.id)
                        case .torrent:
                            TorrentInfoView(properties: properties)
                                .tag(tab.id)
                        case .limits:
                            TorrentLimitsView(properties: properties)
                                .tag(tab.id)
                        }
                    }
                }
            }
        }
        .stateFlow(
            _properties.phase,
            loadingContent: { ProgressView() },
            emptyContent: { EmptyContentView(retry: { _properties.retry() }) },
            failureContent: { FailureContentView(error: $0, retry: { _properties.retry() }) }
        )
        .onAppear {
            _properties.setFetch {
                try await .placeholder
//                try await torrentRepository.getTorrentProperties(id: torrent.id)
            }
        }
        .onDisappear {
            _properties.invalidate()
        }
    }
}

#Preview {
    TorrentPropertiesView(torrent: .placeholder, selected: .constant(.main))
        .environment(TorrentRepository())
}
