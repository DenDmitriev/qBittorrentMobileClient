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
    
    let lastComponentName: String
    let title: TorrentTitle
    let contentType: ContentTypeWithFormat

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
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.availability = try container.decode(Double.self, forKey: .availability)
        self.index = try container.decode(Int.self, forKey: .index)
        self.isSeed = try container.decodeIfPresent(Bool.self, forKey: .isSeed)
        self.name = try container.decode(String.self, forKey: .name)
        self.pieceRange = try container.decode([Int].self, forKey: .pieceRange)
        self.priority = try container.decode(TorrentPriority.self, forKey: .priority)
        self.progress = try container.decode(Double.self, forKey: .progress)
        self.size = try container.decode(Int64.self, forKey: .size)
        self.lastComponentName = name.components(separatedBy: "/").last ?? name
        self.title = TorrentNameParser.parse(lastComponentName)
        let format = URL(fileURLWithPath: lastComponentName).pathExtension
        let contentType = ContentType(from: format)
        self.contentType = .init(type: contentType, format: format)
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
        size: 3185709566,
        lastComponentName: "The.Little.Drummer.Girl.S01E01.1080p.rus.LostFilm.TV.mkv",
        title: TorrentNameParser.parse("The.Little.Drummer.Girl.S01E01.1080p.rus.LostFilm.TV.mkv"),
        contentType: .init(type: .video, format: "mkv")
    )
    
    static let audio: Self = .init(
        availability: 1,
        index: 0,
        isSeed: false,
        name: "The Little Drummer Girl 1 - LostFilm.TV [1080p]/The.Little.Drummer.Girl.S01E01.1080p.rus.LostFilm.TV.wav",
        pieceRange: [0, 379],
        priority: .maximal,
        progress: 1,
        size: 72345679,
        lastComponentName: "The.Little.Drummer.Girl.S01E01.1080p.rus.LostFilm.TV.wav",
        title: TorrentNameParser.parse("The.Little.Drummer.Girl.S01E01.1080p.rus.LostFilm.TV.wav"),
        contentType: .init(type: .audio, format: "wav")
    )
    
    static let subtitle: Self = .init(
        availability: 1,
        index: 0,
        isSeed: false,
        name: "The Little Drummer Girl 1 - LostFilm.TV [1080p]/The.Little.Drummer.Girl.S01E01.1080p.rus.LostFilm.TV.srt",
        pieceRange: [0, 379],
        priority: .high,
        progress: 0,
        size: 654321,
        lastComponentName: "The.Little.Drummer.Girl.S01E01.1080p.rus.LostFilm.TV.srt",
        title: TorrentNameParser.parse("The.Little.Drummer.Girl.S01E01.1080p.rus.LostFilm.TV.srt"),
        contentType: .init(type: .subtitle, format: "srt")
    )
    
    static let file: Self = .init(
        availability: 1,
        index: 0,
        isSeed: false,
        name: "The Little Drummer Girl 1 - LostFilm.TV [1080p]/The.Little.Drummer.Girl.S01E01.1080p.rus.LostFilm.TV.txt",
        pieceRange: [0, 379],
        priority: .doNotDownload,
        progress: 1,
        size: 123456,
        lastComponentName: "The.Little.Drummer.Girl.S01E01.1080p.rus.LostFilm.TV.txt",
        title: TorrentNameParser.parse("The.Little.Drummer.Girl.S01E01.1080p.rus.LostFilm.TV.txt"),
        contentType: .init(type: .text, format: "txt")
    )
}
