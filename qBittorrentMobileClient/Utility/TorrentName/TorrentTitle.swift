//
//  TorrentTitle.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 01.09.2025.
//

import Foundation

struct TorrentTitle: Hashable {
    let name: String
    let season: Int?
    let episode: Int?
    let format: String?
    let year: String?
    let original: String
}
