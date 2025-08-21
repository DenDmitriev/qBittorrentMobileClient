//
//  TorrentState.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 21.08.2025.
//
/*
 error    Some error occurred, applies to paused torrents
 missingFiles    Torrent data files is missing
 uploading    Torrent is being seeded and data is being transferred
 pausedUP    Torrent is paused and has finished downloading
 queuedUP    Queuing is enabled and torrent is queued for upload
 stalledUP    Torrent is being seeded, but no connection were made
 checkingUP    Torrent has finished downloading and is being checked
 forcedUP    Torrent is forced to uploading and ignore queue limit
 allocating    Torrent is allocating disk space for download
 downloading    Torrent is being downloaded and data is being transferred
 metaDL    Torrent has just started downloading and is fetching metadata
 pausedDL    Torrent is paused and has NOT finished downloading
 queuedDL    Queuing is enabled and torrent is queued for download
 stalledDL    Torrent is being downloaded, but no connection were made
 checkingDL    Same as checkingUP, but torrent has NOT finished downloading
 forcedDL    Torrent is forced to downloading to ignore queue limit
 checkingResumeData    Checking resume data on qBt startup
 moving    Torrent is moving to another location
 unknown    Unknown status
 */

import Foundation

enum TorrentState: String, Codable {
    /// Активная загрузка (включает downloading, metaDL, stalledDL, forcedDL)/
    case downloading
    /// Пауза во время загрузки (pausedDL)
    case paused
    /// В очереди на загрузку (queuedDL)
    case queued
    /// Проверка данных (checkingDL, checkingResumeData)
    case checking
    /// Активная раздача (uploading, forcedUP, stalledUP)
    case seeding
    /// Пауза после завершения (pausedUP, queuedUP, checkingUP), торрент скачан
    case pausedSeeding
    /// Ошибка (error)
    case error
    /// Пропавшие файлы (missingFiles)
    case missingFiles
    /// Выделение места на диске (allocating)
    case allocating
    /// Перемещение файлов (moving)
    case moving
    /// Неизвестное состояние (unknown)
    case unknown
}
