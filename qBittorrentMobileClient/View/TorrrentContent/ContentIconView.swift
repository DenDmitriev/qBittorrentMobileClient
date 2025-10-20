//
//  ContentIconView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 30.08.2025.
//

import SwiftUI

struct ContentIconView: View {
    let contentType: ContentTypeWithFormat
    
    var body: some View {
        VStack {
            Circle()
                .fill(.accent)
                .overlay {
                    Image(systemName: contentType.type.icon)
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(1, contentMode: .fit)
                        .foregroundStyle(.white)
                        .padding(8)
                }
            
            Text(contentType.format)
                .font(.caption2)
                .textCase(.uppercase)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
    }
}

#Preview {
    VStack {
        ForEach(ContentType.allCases, id: \.self) { contentType in
            ContentIconView(contentType: .init(type: contentType, format: "ext"))
                .padding()
        }
    }
}
