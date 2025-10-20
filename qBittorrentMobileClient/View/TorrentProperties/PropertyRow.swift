//
//  PropertyRow.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 22.09.2025.
//

import SwiftUI

struct PropertyRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    PropertyRow(label: "Label", value: "Value")
}
