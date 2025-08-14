//
//  Torrent.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 14.08.2025.
//

import Foundation

struct Torrent: Codable, Hashable, Identifiable {
    let addedOn: Int
    let amountLeft: Int64
    let autoTmm: Bool
    let availability: Double
    let category: String
    let completed: Int64
    let completionOn: Int
    let contentPath: String
    let dlLimit: Int
    let dlspeed: Int
    let downloadPath: String
    let downloaded: Int64
    let downloadedSession: Int64
    let eta: Int
    let fLPiecePrio: Bool
    let forceStart: Bool
    let hash: String
    let infohashV1: String
    let infohashV2: String
    let lastActivity: Int
    let magnetUri: String
    let maxRatio: Double
    let maxSeedingTime: Int
    let name: String
    let numComplete: Int
    let numIncomplete: Int
    let numLeechs: Int
    let numSeeds: Int
    let priority: Int
    let progress: Double
    let ratio: Double
    let ratioLimit: Double
    let savePath: String
    let seedingTime: Int
    let seedingTimeLimit: Int
    let seenComplete: Int
    let seqDl: Bool
    let size: Int64
    let state: String
    let superSeeding: Bool
    let tags: String
    let timeActive: Int
    let totalSize: Int64
    let tracker: String
    let trackersCount: Int
    let upLimit: Int
    let uploaded: Int64
    let uploadedSession: Int64
    let upspeed: Int
    
    var id: String {
        hash
    }
    
    enum CodingKeys: String, CodingKey {
        case addedOn = "added_on"
        case amountLeft = "amount_left"
        case autoTmm = "auto_tmm"
        case availability
        case category
        case completed
        case completionOn = "completion_on"
        case contentPath = "content_path"
        case dlLimit = "dl_limit"
        case dlspeed
        case downloadPath = "download_path"
        case downloaded
        case downloadedSession = "downloaded_session"
        case eta
        case fLPiecePrio = "f_l_piece_prio"
        case forceStart = "force_start"
        case hash
        case infohashV1 = "infohash_v1"
        case infohashV2 = "infohash_v2"
        case lastActivity = "last_activity"
        case magnetUri = "magnet_uri"
        case maxRatio = "max_ratio"
        case maxSeedingTime = "max_seeding_time"
        case name
        case numComplete = "num_complete"
        case numIncomplete = "num_incomplete"
        case numLeechs = "num_leechs"
        case numSeeds = "num_seeds"
        case priority
        case progress
        case ratio
        case ratioLimit = "ratio_limit"
        case savePath = "save_path"
        case seedingTime = "seeding_time"
        case seedingTimeLimit = "seeding_time_limit"
        case seenComplete = "seen_complete"
        case seqDl = "seq_dl"
        case size
        case state
        case superSeeding = "super_seeding"
        case tags
        case timeActive = "time_active"
        case totalSize = "total_size"
        case tracker
        case trackersCount = "trackers_count"
        case upLimit = "up_limit"
        case uploaded
        case uploadedSession = "uploaded_session"
        case upspeed
    }
}

extension Torrent {
    static let placeholder: Self = .init(
        addedOn: 1754685932,
        amountLeft: 19243466752,
        autoTmm: false,
        availability: 0.20100000500679016,
        category: "",
        completed: 18383634432,
        completionOn: -10800,
        contentPath: "/mnt/ssd/The Godfather Collection",
        dlLimit: 0,
        dlspeed: 0,
        downloadPath: "",
        downloaded: 19500990734,
        downloadedSession: 19500990734,
        eta: 8640000,
        fLPiecePrio: false,
        forceStart: false,
        hash: "d288323bb2c1b633e90394c5b1ac5c2ed2cb2b45",
        infohashV1: "d288323bb2c1b633e90394c5b1ac5c2ed2cb2b45",
        infohashV2: "",
        lastActivity: 1754688672,
        magnetUri: "magnet:?xt=urn:btih:d288323bb2c1b633e90394c5b1ac5c2ed2cb2b45&dn=The%20Godfather%20Collection&tr=http%3a%2f%2fbt.t-ru.org%2fann%3fmagnet",
        maxRatio: -1,
        maxSeedingTime: -1,
        name: "The Godfather Collection: The Coppola Restoration (Francis Ford Coppola) [1972/1974/1990, США, драма,]",
        numComplete: 5,
        numIncomplete: 87,
        numLeechs: 0,
        numSeeds: 0,
        priority: 1,
        progress: 0.4885742949503957,
        ratio: 0,
        ratioLimit: -2,
        savePath: "/mnt/ssd",
        seedingTime: 72295,
        seedingTimeLimit: -2,
        seenComplete: 1754688672,
        seqDl: false,
        size: 37627101184,
        state: "pausedDL",
        superSeeding: false,
        tags: "",
        timeActive: 75035,
        totalSize: 96637579228,
        tracker: "http://bt.t-ru.org/ann?magnet",
        trackersCount: 1,
        upLimit: 0,
        uploaded: 0,
        uploadedSession: 0,
        upspeed: 0
    )
}
