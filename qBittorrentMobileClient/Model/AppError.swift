//
//  AppError.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 01.09.2025.
//

import Foundation

enum AppError: LocalizedError {
    case some(message: String)
    
    var errorDescription: String? {
        switch self {
        case .some(let message):
            return message
        }
    }
}
