//
//  ModernTextFieldStyle.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 12.09.2025.
//

import SwiftUI

extension TextFieldStyle where Self == ModernTextFieldStyle {
    static var modern: ModernTextFieldStyle {
        ModernTextFieldStyle()
    }
}

struct ModernTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(12)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.gray.opacity(0.3), lineWidth: 1)
            )
    }
}

#Preview {
    TextField("Username", text: .constant("User"))
        .textFieldStyle(.modern)
}
