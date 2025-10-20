//
//  URLFormatter.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 12.09.2025.
//

import Foundation

class URLFormatter {
    enum Error: LocalizedError {
        case invalidURLFormat(String)
        
        var errorDescription: String? {
            switch self {
            case .invalidURLFormat(let url):
                return String(localized: "Invalid URL format: \(url)")
            }
        }
    }
    
    static func create(_ urlString: String) throws -> URL {
        var formattedUrl = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Добавляем https:// по умолчанию, если схема не указана
        if !formattedUrl.hasPrefix("http://") && !formattedUrl.hasPrefix("https://") {
            formattedUrl = "https://" + formattedUrl
        }
        
        // Проверяем, является ли строка валидным URL
        guard let url = URL(string: formattedUrl), url.scheme != nil, url.host != nil else {
            throw Error.invalidURLFormat(urlString)
        }
        
        return url
    }
}
