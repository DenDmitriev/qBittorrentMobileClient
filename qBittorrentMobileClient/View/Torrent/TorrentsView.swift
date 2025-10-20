//
//  TorrentsView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 13.08.2025.
//

import SwiftUI

struct TorrentsView: View {
    @StateFlow var torrents: [Torrent]?
    @Environment(TorrentRepository.self) private var torrentRepository
    @State private var isAddTorrentPresented = false
    @State private var selectedCategory: TorrentCategory.ID? = .all
    @State private var categories: [TorrentCategory] = [.all]
    @SceneStorage(SceneStorageKeys.sort) private var sort: TorrentSort = .name
    @SceneStorage(SceneStorageKeys.sortDirection) private var sortDirection: SortDirection = .ascending
    
    init(torrents: [Torrent]? = nil) {
        self._torrents = .init(value: torrents)
    }
    
    var body: some View {
        Group {
            if let torrents {
                PageView(selected: $selectedCategory, pages: $categories) {
                    ForEach(categories) { category in
                        TorrentCategoryView(
                            category: category,
                            torrents: torrents,
                            sort: $sort,
                            sortDirection: $sortDirection
                        )
                        .tag(category.id)
                    }
                }
            }
        }
        .background(Color.backgroundSecond)
        .ignoresSafeArea(.all, edges: .bottom)
        .stateFlow(
            _torrents.phase,
            loadingContent: { SkeletonContentView(height: 120) },
            emptyContent: { EmptyContentView(retry: { _torrents.retry() }) },
            failureContent: { FailureContentView(error: $0, retry: { _torrents.retry() }) }
        )
        .sheet(isPresented: $isAddTorrentPresented) {
            AddTorrentView()
        }
        .environment(torrentRepository)
        .navigationTitle(String(localized: "Torrents"))
        .toolbar {
            ToolbarItem(placement: .automatic) {
                ServerStatusIcon(error: _torrents.error)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                SortMenu(sort: $sort, sortDirection: $sortDirection)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(String(localized: "Add Torrent"), systemImage: "plus", action: showAddTorrentSheet)
            }
        }
        .onAppear {
            _torrents.setFetch {
                try await torrentRepository.getTorrentsInfo()
//                return .placeholder
            }
        }
        .onDisappear {
            _torrents.invalidate()
        }
        .onChange(of: torrents ?? []) { _, newTorrents in
            updateCategories(torrents: newTorrents)
        }
    }
    
    private func showAddTorrentSheet() {
        isAddTorrentPresented = true
    }
    
    private func updateCategories(torrents: [Torrent]) {
        var categories = Set(
            Set(torrents.map({ $0.state }))
                .map({ TorrentCategory(state: $0) })
        ).sorted(by: { $0.index < $1.index })
        categories.insert(.all, at: 0)
        self.categories = categories
    }
}

#Preview {
    NavigationStack {
        TorrentsView(torrents: .placeholder)
    }
    .environment(TorrentRepository())
}
