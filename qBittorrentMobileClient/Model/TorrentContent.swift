//
//  TorrentContent.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 28.08.2025.
//

import Foundation

enum TorrentPriority: Int, Codable, CaseIterable, Identifiable {
    case doNotDownload = 0
    case normal = 1
    case high = 6
    case maximal = 7
    
    var id: Int { rawValue }
    
    var title: String {
        switch self {
        case .doNotDownload:
            return String(localized: "Not download")
        case .normal:
            return String(localized: "Normal")
        case .high:
            return String(localized: "High")
        case .maximal:
            return String(localized: "Maximal")
        }
    }
}

struct TorrentContent: Codable, Hashable, Identifiable {
    var id: Int { index }
    let availability: Double
    let index: Int
    let isSeed: Bool?
    let name: String
    let pieceRange: [Int]
    let priority: TorrentPriority
    let progress: Double
    let size: Int64

    enum CodingKeys: String, CodingKey {
        case availability
        case index
        case isSeed = "is_seed"
        case name
        case pieceRange = "piece_range"
        case priority
        case progress
        case size
    }
}

extension TorrentContent {
    var fileExtension: String {
        let components = name.components(separatedBy: "/")
        let fileName = components.last ?? name
        return URL(fileURLWithPath: fileName).pathExtension
    }
    
    var contentType: ContentType {
        ContentType(from: fileExtension)
    }
}

extension TorrentContent {
    var remainingSize: Int64 {
        Int64(Double(size) * (1.0 - progress))
    }
}

extension TorrentContent {
    static let movie: Self = .init(
        availability: 1,
        index: 0,
        isSeed: false,
        name: "The Little Drummer Girl 1 - LostFilm.TV [1080p]/The.Little.Drummer.Girl.S01E01.1080p.rus.LostFilm.TV.mkv",
        pieceRange: [0, 379],
        priority: .normal,
        progress: 0.6,
        size: 3185709566
    )
    
    static let audio: Self = .init(
        availability: 1,
        index: 0,
        isSeed: false,
        name: "The Little Drummer Girl 1 - LostFilm.TV [1080p]/The.Little.Drummer.Girl.S01E01.1080p.rus.LostFilm.TV.wav",
        pieceRange: [0, 379],
        priority: .maximal,
        progress: 1,
        size: 72345679
    )
    
    static let subtitle: Self = .init(
        availability: 1,
        index: 0,
        isSeed: false,
        name: "The Little Drummer Girl 1 - LostFilm.TV [1080p]/The.Little.Drummer.Girl.S01E01.1080p.rus.LostFilm.TV.srt",
        pieceRange: [0, 379],
        priority: .high,
        progress: 0,
        size: 654321
    )
    
    static let file: Self = .init(
        availability: 1,
        index: 0,
        isSeed: false,
        name: "The Little Drummer Girl 1 - LostFilm.TV [1080p]/The.Little.Drummer.Girl.S01E01.1080p.rus.LostFilm.TV.txt",
        pieceRange: [0, 379],
        priority: .doNotDownload,
        progress: 1,
        size: 123456
    )
}
