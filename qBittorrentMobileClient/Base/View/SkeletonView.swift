//
//  SkeletonView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 09.09.2025.
//

import SwiftUI

struct BoneView: View {
    var body: some View {
        Color.background
    }
}

struct SkeletonRectangleView: View {
    let height: CGFloat
    
    var body: some View {
        BoneView()
            .frame(height: height)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    init(height: CGFloat = 120) {
        self.height = height
    }
}

struct SkeletonContentView: View {
    let height: CGFloat
    
    var body: some View {
        ScrollView {
            VStack {
                SkeletonRectangleView(height: height)
                SkeletonRectangleView(height: height)
                SkeletonRectangleView(height: height)
            }
            .shimmering(active: true)
            .padding()
        }
        .background(Color.backgroundSecond)
        .scrollDisabled(true)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    SkeletonContentView(height: 120)
}
