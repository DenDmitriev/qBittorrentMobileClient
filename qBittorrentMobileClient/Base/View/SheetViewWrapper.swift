//
//  SheetViewWrapper.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 23.09.2025.
//

import SwiftUI

struct SheetViewWrapper<Content: View>: View {
    let title: String
    let content: () -> Content
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Text(title)
                    .font(.headline)
                Spacer()
            }
            .overlay(alignment: .leading) {
                HStack {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            content()
        }
    }
}

#Preview {
    SheetViewWrapper(title: "Title") {
        Text("Hello, world!")
    }
}
