//
//  ContentType.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 30.08.2025.
//

import Foundation

enum ContentType: String, CaseIterable {
    case video
    case audio
    case subtitle
    case image
    case text
    case archive
    case playlist
    case other
    
    init(from extension: String) {
        switch `extension`.lowercased() {
        // Видео
        case "mp4", "mkv", "avi", "mov", "wmv", "flv", "mpeg", "mpg", "m2ts", "ts", "vob":
            self = .video
        // Аудио
        case "mp3", "wav", "flac", "aac", "ogg", "m4a", "wma":
            self = .audio
        // Субтитры
        case "srt", "sub", "ass", "vtt", "ssa":
            self = .subtitle
        // Изображения
        case "jpg", "jpeg", "png", "bmp", "gif":
            self = .image
        // Текстовые файлы и метаданные
        case "txt", "nfo", "md":
            self = .text
        // Архивы
        case "zip", "rar", "7z":
            self = .archive
        // Плейлисты
        case "m3u", "m3u8", "pls":
            self = .playlist
        // Все остальные
        default:
            self = .other
        }
    }
    
    var icon: String {
        switch self {
        case .video:
            return "film"
        case .audio:
            return "music.note"
        case .subtitle:
            return "captions.bubble"
        case .image:
            return "photo"
        case .text:
            return "doc.text"
        case .archive:
            return "archivebox"
        case .playlist:
            return "list.bullet"
        case .other:
            return "doc"
        }
    }
}
