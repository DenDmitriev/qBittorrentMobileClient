//
//  TimeRemaingFormatter.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 30.08.2025.
//

import Foundation

extension DateComponentsFormatter {
    static let timeRemaingFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        return formatter
    }()
}
