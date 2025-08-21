//
//  LaunchView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 21.08.2025.
//

import SwiftUI

struct LaunchView: View {
    var body: some View {
        ZStack {
            Color.clear
            Image(.qbittorrentLogo)
                .resizable()
                .scaledToFit()
                .frame(width: 100)
        }
    }
}

#Preview {
    LaunchView()
}
