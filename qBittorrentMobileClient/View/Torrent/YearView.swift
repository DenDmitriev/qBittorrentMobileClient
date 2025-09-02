//
//  YearView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 02.09.2025.
//

import SwiftUI

struct YearView: View {
    let year: String
    
    var body: some View {
        Text(year)
            .font(.caption.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Capsule().fill(.backgroundSecond))
            .foregroundStyle(.secondary)
    }
}

#Preview {
    YearView(year: "2025")
}
