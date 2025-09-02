//
//  TorrentTitle.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 01.09.2025.
//

import Foundation

enum TorrentTitle: Hashable {
    case movie(Movie)
    case series(Series)
    case other(Other)
    
    struct Other: Identifiable, Hashable {
        var id: String { original }
        let original: String
    }
    
    struct Series: Identifiable, Hashable {
        var id: String { original }
        let name: String
        let session: Int?
        let episode: Int?
        let format: String?
        let year: String?
        let original: String
    }

    struct Movie: Identifiable, Hashable {
        var id: String { original }
        let name: String
        let format: String?
        let year: String?
        let original: String
    }
}

extension TorrentTitle.Movie {
    static let placeholder: Self = .init(
        name: "The Tree of Life",
        format: "1080p",
        year: "2011",
        original: "The.Tree.of.Life.2011.1080p.BluRay.2xRus.Eng.HDCLUB.mkv"
    )
}

extension TorrentTitle.Series {
    static let placeholder: Self = .init(
        name: "Wednesday",
        session: 2,
        episode: 5,
        format: "1080p",
        year: "2025",
        original: "Wednesday.S02E02.1080p.rus.LostFilm.TV.mkv"
    )
}

extension TorrentTitle.Other {
    static let placeholder: Self = .init(original: "Some File")
}
