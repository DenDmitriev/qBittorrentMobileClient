//
//  TintColor.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 21.08.2025.
//

import SwiftUI

private struct TintKey: EnvironmentKey {
    static let defaultValue: Color = Color.accentColor
}

extension EnvironmentValues {
    var tintColor: Color {
        get { self[TintKey.self] }
        set { self[TintKey.self] = newValue }
    }
}
