//
//  TorrentProperties.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 12.09.2025.
//

import Foundation

/// Структура для представления общих свойств торрента из qBittorrent WebUI API (метод "Get torrent generic properties").
/// Значения с -1 обычно означают "нет лимита" или "не применимо".
struct TorrentGenericProperties: Codable, Hashable, Identifiable {
    // MARK: - Идентификаторы и основные метаданные (строки, хэши)
    /// Хэш торрента (основной идентификатор).
    let hash: String
    
    /// Имя торрента.
    let name: String
    
    /// Infohash v1 (для совместимости с v1 торрентами).
    let infohashV1: String
    
    /// Infohash v2 (для v2 торрентов; может быть пустым).
    let infohashV2: String
    
    /// Комментарий к торренту.
    let comment: String
    
    /// Приложение/клиент, создавший торрент (например, "uTorrent/3.6").
    let createdBy: String
    
    /// Путь сохранения торрента.
    let savePath: String
    
    /// Путь загрузки (может быть пустым, если не применимо).
    let downloadPath: String
    
    /// Дата добавления торрента (Unix timestamp).
    let additionDate: Int
    
    /// Дата завершения загрузки (Unix timestamp; -1 если не завершено).
    let completionDate: Int
    
    /// Дата создания торрента (Unix timestamp).
    let creationDate: Int
    
    /// Время последней видимости торрента (Unix timestamp).
    let lastSeen: Int
    
    /// Общий размер торрента в байтах.
    let totalSize: Int
    
    /// Размер одного куска (piece) в байтах.
    let pieceSize: Int
    
    /// Текущая скорость загрузки (байты/с).
    let dlSpeed: Int
    
    /// Средняя скорость загрузки (байты/с).
    let dlSpeedAvg: Int
    
    /// Текущая скорость отдачи (байты/с).
    let upSpeed: Int
    
    /// Средняя скорость отдачи (байты/с).
    let upSpeedAvg: Int
    
    /// Лимит скорости загрузки (байты/с; -1 = без лимита).
    let dlLimit: Int
    
    /// Лимит скорости отдачи (байты/с; -1 = без лимита).
    let upLimit: Int
    
    /// Лимит количества подключений.
    let nbConnectionsLimit: Int
    
    /// Текущее количество подключений.
    let nbConnections: Int
    
    /// Текущее количество пиров.
    let peers: Int
    
    /// Общее количество пиров (включая потенциальных).
    let peersTotal: Int
    
    /// Текущее количество сидов.
    let seeds: Int
    
    /// Общее количество сидов (включая потенциальных).
    let seedsTotal: Int
    
    /// Количество загруженных кусков.
    let piecesHave: Int
    
    /// Общее количество кусков в торренте.
    let piecesNum: Int
    
    /// Оставшееся время до завершения (ETA, секунды; 8640000 = бесконечно).
    let eta: Int
    
    /// Прошедшее время с добавления (секунды).
    let timeElapsed: Int
    
    /// Время сидирования (секунды).
    let seedingTime: Int
    
    /// Время до следующего переобъявления (reannounce, секунды).
    let reannounce: Int
    
    /// Общий объём загруженных данных (байты).
    let totalDownloaded: Int
    
    /// Общий объём загруженных данных за сессию (байты).
    let totalDownloadedSession: Int
    
    /// Общий объём отданных данных (байты).
    let totalUploaded: Int
    
    /// Общий объём отданных данных за сессию (байты).
    let totalUploadedSession: Int
    
    /// Общий объём потраченных впустую данных (байты, например, из-за ошибок).
    let totalWasted: Int
    
    /// Коэффициент шаринга (ratio = uploaded / downloaded).
    let shareRatio: Double
    
    /// Флаг приватного торрента.
    let isPrivate: Bool
    
    var id: String { hash }
    
    enum CodingKeys: String, CodingKey {
        case additionDate = "addition_date"
        case comment
        case completionDate = "completion_date"
        case createdBy = "created_by"
        case creationDate = "creation_date"
        case dlLimit = "dl_limit"
        case dlSpeed = "dl_speed"
        case dlSpeedAvg = "dl_speed_avg"
        case downloadPath = "download_path"
        case eta
        case hash
        case infohashV1 = "infohash_v1"
        case infohashV2 = "infohash_v2"
        case isPrivate = "is_private"
        case lastSeen = "last_seen"
        case name
        case nbConnections = "nb_connections"
        case nbConnectionsLimit = "nb_connections_limit"
        case peers
        case peersTotal = "peers_total"
        case pieceSize = "piece_size"
        case piecesHave = "pieces_have"
        case piecesNum = "pieces_num"
        case reannounce
        case savePath = "save_path"
        case seedingTime = "seeding_time"
        case seeds
        case seedsTotal = "seeds_total"
        case shareRatio = "share_ratio"
        case timeElapsed = "time_elapsed"
        case totalDownloaded = "total_downloaded"
        case totalDownloadedSession = "total_downloaded_session"
        case totalSize = "total_size"
        case totalUploaded = "total_uploaded"
        case totalUploadedSession = "total_uploaded_session"
        case totalWasted = "total_wasted"
        case upLimit = "up_limit"
        case upSpeed = "up_speed"
        case upSpeedAvg = "up_speed_avg"
    }
}

extension TorrentGenericProperties {
    static var placeholder: Self = {
        let url = Bundle.main.url(forResource: "TorrentProperties", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return try! JSONDecoder().decode(TorrentGenericProperties.self, from: data)
    }()
}
