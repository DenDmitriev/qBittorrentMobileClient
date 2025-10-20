//
//  MainView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 25.08.2025.
//

import SwiftUI

struct MainView: View {
    @State private var torrentRepository: TorrentRepository = .init()
    @State private var navigationModel: NavigationModel = .init()
    @State private var error: AppError?
    
    var body: some View {
        NavigationStack(path: $navigationModel.path) {
            TorrentsView()
                .navigationDestination(for: Router.self) { route in
                    Router.destination(route: route)
                }
        }
        .environment(navigationModel)
        .environment(torrentRepository)
    }
}

#Preview {
    MainView()
}
