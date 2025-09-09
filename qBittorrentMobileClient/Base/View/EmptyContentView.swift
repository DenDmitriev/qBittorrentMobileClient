//
//  EmptyContentView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 09.09.2025.
//

import SwiftUI

struct EmptyContentView: View {
    let retry: () -> Void
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                Image(systemName: "tray.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .foregroundStyle(.gray.gradient)
                
                Text("No Data Available")
                    .font(.system(.title2, weight: .semibold))
                    .foregroundStyle(.primary)
                
                Text("There’s nothing to show here yet.")
                    .font(.system(.subheadline))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                Button(action: retry) {
                    Text("Try Again")
                }
                .buttonStyle(.modernCapsule(.primary))
                .padding(.top, 8)
            }
            .padding(.vertical, 24)
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
}

#Preview {
    EmptyContentView(retry: {})
}
