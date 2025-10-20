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
    let dlSpeed: Int
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
    let state: TorrentState
    let superSeeding: Bool
    let tags: String
    let timeActive: Int
    let totalSize: Int64
    let tracker: String
    let trackersCount: Int
    let upLimit: Int
    let uploaded: Int64
    let uploadedSession: Int64
    let upSpeed: Int
    
    var id: String {
        hash
    }
    let title: TorrentTitle
    let torrentCategory: TorrentCategory
    
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
        case dlSpeed = "dlspeed"
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
        case upSpeed = "upspeed"
    }
}

extension Torrent {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        addedOn = try container.decode(Int.self, forKey: .addedOn)
        amountLeft = try container.decode(Int64.self, forKey: .amountLeft)
        autoTmm = try container.decode(Bool.self, forKey: .autoTmm)
        availability = try container.decode(Double.self, forKey: .availability)
        category = try container.decode(String.self, forKey: .category)
        completed = try container.decode(Int64.self, forKey: .completed)
        completionOn = try container.decode(Int.self, forKey: .completionOn)
        contentPath = try container.decode(String.self, forKey: .contentPath)
        dlLimit = try container.decode(Int.self, forKey: .dlLimit)
        dlSpeed = try container.decode(Int.self, forKey: .dlSpeed)
        downloadPath = try container.decode(String.self, forKey: .downloadPath)
        downloaded = try container.decode(Int64.self, forKey: .downloaded)
        downloadedSession = try container.decode(Int64.self, forKey: .downloadedSession)
        eta = try container.decode(Int.self, forKey: .eta)
        fLPiecePrio = try container.decode(Bool.self, forKey: .fLPiecePrio)
        forceStart = try container.decode(Bool.self, forKey: .forceStart)
        hash = try container.decode(String.self, forKey: .hash)
        infohashV1 = try container.decode(String.self, forKey: .infohashV1)
        infohashV2 = try container.decode(String.self, forKey: .infohashV2)
        lastActivity = try container.decode(Int.self, forKey: .lastActivity)
        magnetUri = try container.decode(String.self, forKey: .magnetUri)
        maxRatio = try container.decode(Double.self, forKey: .maxRatio)
        maxSeedingTime = try container.decode(Int.self, forKey: .maxSeedingTime)
        name = try container.decode(String.self, forKey: .name)
        numComplete = try container.decode(Int.self, forKey: .numComplete)
        numIncomplete = try container.decode(Int.self, forKey: .numIncomplete)
        numLeechs = try container.decode(Int.self, forKey: .numLeechs)
        numSeeds = try container.decode(Int.self, forKey: .numSeeds)
        priority = try container.decode(Int.self, forKey: .priority)
        progress = try container.decode(Double.self, forKey: .progress)
        ratio = try container.decode(Double.self, forKey: .ratio)
        ratioLimit = try container.decode(Double.self, forKey: .ratioLimit)
        savePath = try container.decode(String.self, forKey: .savePath)
        seedingTime = try container.decode(Int.self, forKey: .seedingTime)
        seedingTimeLimit = try container.decode(Int.self, forKey: .seedingTimeLimit)
        seenComplete = try container.decode(Int.self, forKey: .seenComplete)
        seqDl = try container.decode(Bool.self, forKey: .seqDl)
        size = try container.decode(Int64.self, forKey: .size)
        superSeeding = try container.decode(Bool.self, forKey: .superSeeding)
        tags = try container.decode(String.self, forKey: .tags)
        timeActive = try container.decode(Int.self, forKey: .timeActive)
        totalSize = try container.decode(Int64.self, forKey: .totalSize)
        tracker = try container.decode(String.self, forKey: .tracker)
        trackersCount = try container.decode(Int.self, forKey: .trackersCount)
        upLimit = try container.decode(Int.self, forKey: .upLimit)
        uploaded = try container.decode(Int64.self, forKey: .uploaded)
        uploadedSession = try container.decode(Int64.self, forKey: .uploadedSession)
        upSpeed = try container.decode(Int.self, forKey: .upSpeed)
        
        // Декодирование строки состояния и преобразование в TorrentState
        let stateString = try container.decode(String.self, forKey: .state)
        switch stateString {
        case "downloading", "metaDL", "stalledDL", "forcedDL":
            state = .downloading
        case "pausedDL":
            state = .paused
        case "queuedDL":
            state = .queued
        case "checkingDL", "checkingResumeData", "checkingUP":
            state = .checking
        case "uploading", "forcedUP", "stalledUP":
            state = .seeding
        case "pausedUP", "queuedUP":
            state = .pausedSeeding
        case "error":
            state = .error
        case "missingFiles":
            state = .missingFiles
        case "allocating":
            state = .allocating
        case "moving":
            state = .moving
        default:
            state = .unknown
        }
        
        self.title = TorrentNameParser.parse(name)
        torrentCategory = TorrentCategory(state: state)
    }
}

extension Torrent {
    static let placeholder: Self = {
        let url = Bundle.main.url(forResource: "Torrent", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let torrent = try! JSONDecoder().decode(Torrent.self, from: data)
        
        return torrent
    }()
}

extension Array<Torrent> {
    static var placeholder: Self = {
        guard
            let url = Bundle.main.url(forResource: "JSONTorrents", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let torrents = try? JSONDecoder().decode([Torrent].self, from: data)
        else {
            return []
        }
        
        return torrents
    }()
}
