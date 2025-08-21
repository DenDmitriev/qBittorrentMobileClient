//
//  CircularProgressView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 19.08.2025.
//

import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    
    private var lineWidth: CGFloat { size.width / 8 }
    private var font: Font { .system(size: size.width / 3) }
    @State private var size: CGSize = .zero
    @Environment(\.tintColor) private var tintColor
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    tintColor.opacity(0.5),
                    lineWidth: lineWidth
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    tintColor,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
        }
        .onGeometryChange(for: CGRect.self) { proxy in
            proxy.frame(in: .local)
        } action: { newValue in
            size = newValue.size
        }
        .padding(lineWidth / 2)
    }
}

#Preview {
    VStack {
        CircularProgressView(progress: 1)
            .frame(width: 50)
        CircularProgressView(progress: 0.84)
            .frame(width: 100)
        CircularProgressView(progress: 0.41)
            .frame(width: 200)
    }
}
