//
//  ContentIconView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 30.08.2025.
//

import SwiftUI

struct ContentIconView: View {
    let contentType: ContentType
    
    var body: some View {
        Image(systemName: contentType.icon)
            .resizable()
            .scaledToFit()
    }
}

#Preview {
    VStack {
        ForEach(ContentType.allCases, id: \.self) { contentType in
            ContentIconView(contentType: contentType)
                .padding()
        }
    }
}
