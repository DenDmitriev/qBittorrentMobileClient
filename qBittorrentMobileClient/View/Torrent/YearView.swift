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
            .foregroundStyle(.secondary)
    }
}

#Preview {
    YearView(year: "2025")
}
