//
//  TorrentContentView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 28.08.2025.
//

import SwiftUI

struct TorrentContentView: View {
    let torrent: Torrent

    @Environment(TorrentRepository.self) private var torrentRepository
    @StateFlow private var contents: [TorrentContent]?
    @State private var isShowProperties = false
    @State private var selectedProperty: TorrentPropertiesTab.ID?
    
    init(torrent: Torrent) {
        self.torrent = torrent
        self._contents = .init(value: nil)
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            ScrollView(.vertical) {
                if let contents {
                    LazyVStack {
                        HStack(alignment: .top) {
                            BubbleButton(image: "text.document", title: "Properties") {
                                handleTapShowProperty(.main)
                            }
                            BubbleButton(image: "arrow.down.document", title: "Torrent") {
                                handleTapShowProperty(.torrent)
                            }
                            BubbleButton(image: "arrowshape.down.fill", title: "Limits") {
                                handleTapShowProperty(.limits)
                            }
                            
                            Spacer()
                        }
                        .padding(.bottom)
                        
                        ForEach(contents) { content in
                            TorrentContentItemView(torrent: torrent, content: content)
                        }
                    }
                    .padding()
                }
            }
            .background(Color.backgroundSecond)
        }
        .stateFlow(
            _contents.phase,
            loadingContent: { SkeletonContentView(height: 137) },
            emptyContent: { EmptyContentView(retry: { _contents.retry() }) },
            failureContent: { FailureContentView(error: $0, retry: { _contents.retry() }) }
        )
        .navigationTitle(String(localized: "Torrent Content"))
        .toolbarBackground(.accent, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .sheet(isPresented: $isShowProperties) {
            SheetViewWrapper(title: "Properties") {
                TorrentPropertiesView(torrent: torrent, selected: $selectedProperty)
            }
        }
        .onAppear {
            _contents.setFetch {
                try await torrentRepository.getTorrentContent(id: torrent.id)
//                return .placeholder
            }
        }
        .onDisappear {
            _contents.invalidate()
        }
    }
    
    private func handleTapShowProperty(_ property: TorrentPropertiesTab) {
        selectedProperty = property
        isShowProperties = true
    }
}

#Preview {
    NavigationStack {
        TorrentContentView(torrent: .placeholder)
    }
    .environment(TorrentRepository())
}
