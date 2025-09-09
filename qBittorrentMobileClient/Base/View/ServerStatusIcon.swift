//
//  ServerStatusIcon.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 25.08.2025.
//

import SwiftUI

struct ServerStatusIcon: View {
    let error: Error?
    
    var body: some View {
        Circle()
            .fill(getStatusColor())
            .frame(width: 5)
    }
    
    private func getStatusColor() -> Color {
        if error == nil {
            return .green
        } else {
            return .red
        }
    }
}

#Preview {
    ServerStatusIcon(error: nil)
}
