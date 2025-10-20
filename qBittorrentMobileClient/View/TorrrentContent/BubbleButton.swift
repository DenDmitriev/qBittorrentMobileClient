//
//  BubbleButton.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 22.09.2025.
//

import SwiftUI

struct BubbleButton: View {
    let image: String
    let title: String
    let action: () -> Void
    
    @Environment(\.isEnabled) private var isEnabled
    
    var body: some View {
        VStack(spacing: 8) {
            Button {
                action()
            } label: {
                Image(systemName: image)
                    .foregroundStyle(.white)
            }
            .padding()
            .background {
                Circle()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Capsule()
                            .fill(.accent.gradient)
                            .opacity(isEnabled ? 1.0 : 0.5)
                    )
            }
            
            Text(title)
                .font(.caption)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .frame(maxWidth: 50)
    }
}

#Preview {
    BubbleButton(image: "swift", title: "Title", action: {})
}
