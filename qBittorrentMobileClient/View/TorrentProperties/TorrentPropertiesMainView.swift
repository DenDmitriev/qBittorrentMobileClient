//
//  TorrentPropertiesMainView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 22.09.2025.
//

import SwiftUI

/// Вкладка "Основные": объединяет метаданные, пути, размеры, даты (кроме lastSeen) и куски.
struct TorrentPropertiesMainView: View {
    let properties: TorrentGenericProperties
    
    private func formattedDate(_ timestamp: Int) -> String {
        guard timestamp > 0 else { return "Не завершено" }
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func formattedSize(_ bytes: Int) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB, .useGB]
        return formatter.string(fromByteCount: Int64(bytes))
    }
    
    var body: some View {
        List {
            Section(header: Text("Метаданные"), footer: Text("Основная информация о торренте")) {
                PropertyRow(label: "Имя", value: properties.name)
                PropertyRow(label: "Хэш", value: properties.hash)
                PropertyRow(label: "Infohash v1", value: properties.infohashV1)
                PropertyRow(label: "Infohash v2", value: properties.infohashV2.isEmpty ? "Отсутствует" : properties.infohashV2)
                PropertyRow(label: "Комментарий", value: properties.comment)
                PropertyRow(label: "Создан", value: properties.createdBy)
            }
            
            Section(header: Text("Пути"), footer: Text("Директории сохранения и загрузки")) {
                PropertyRow(label: "Путь сохранения", value: properties.savePath)
                PropertyRow(label: "Путь загрузки", value: properties.downloadPath.isEmpty ? "Отсутствует" : properties.downloadPath)
            }
            
            Section(header: Text("Даты"), footer: Text("Ключевые временные метки")) {
                PropertyRow(label: "Дата добавления", value: formattedDate(properties.additionDate))
                PropertyRow(label: "Дата завершения", value: formattedDate(properties.completionDate))
                PropertyRow(label: "Дата создания", value: formattedDate(properties.creationDate))
            }
            
            Section(header: Text("Размеры"), footer: Text("Объёмы данных торрента")) {
                PropertyRow(label: "Общий размер", value: formattedSize(properties.totalSize))
                PropertyRow(label: "Размер куска", value: formattedSize(properties.pieceSize))
            }
            
            Section(header: Text("Куски"), footer: Text("Прогресс загрузки кусков")) {
                PropertyRow(label: "Загружено кусков", value: "\(properties.piecesHave)")
                PropertyRow(label: "Всего кусков", value: "\(properties.piecesNum)")
                PropertyRow(label: "Прогресс", value: String(format: "%.1f%%", Double(properties.piecesHave) / Double(properties.piecesNum) * 100))
            }
        }
    }
}

/// Вкладка "Торрент": объединяет подключения, время, передачу, дополнительные свойства и последнюю активность.
struct TorrentInfoView: View {
    let properties: TorrentGenericProperties
    
    private func formattedTime(_ seconds: Int) -> String {
        guard seconds >= 0 else { return "Неограничено" }
        if seconds >= 86400 {
            let days = seconds / 86400
            let hours = (seconds % 86400) / 3600
            return "\(days) д. \(hours) ч."
        } else if seconds >= 3600 {
            let hours = seconds / 3600
            let minutes = (seconds % 3600) / 60
            return "\(hours) ч. \(minutes) мин."
        } else {
            let minutes = seconds / 60
            let secs = seconds % 60
            return "\(minutes) мин. \(secs) сек."
        }
    }
    
    private func formattedSize(_ bytes: Int) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB, .useGB]
        return formatter.string(fromByteCount: Int64(bytes))
    }
    
    private func formattedDate(_ timestamp: Int) -> String {
        guard timestamp > 0 else { return "Не завершено" }
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var body: some View {
        List {
            Section(header: Text("Подключения"), footer: Text("Информация о пирах и сидах")) {
                PropertyRow(label: "Текущие подключения", value: "\(properties.nbConnections)")
                PropertyRow(label: "Лимит подключений", value: "\(properties.nbConnectionsLimit)")
                PropertyRow(label: "Текущие пиры", value: "\(properties.peers)")
                PropertyRow(label: "Всего пиров", value: "\(properties.peersTotal)")
                PropertyRow(label: "Текущие сиды", value: "\(properties.seeds)")
                PropertyRow(label: "Всего сидов", value: "\(properties.seedsTotal)")
            }
            
            Section(header: Text("Время"), footer: Text("Временные интервалы и последняя активность")) {
                PropertyRow(label: "Оставшееся время (ETA)", value: formattedTime(properties.eta))
                PropertyRow(label: "Прошедшее время", value: formattedTime(properties.timeElapsed))
                PropertyRow(label: "Время сидирования", value: formattedTime(properties.seedingTime))
                PropertyRow(label: "До переобъявления", value: formattedTime(properties.reannounce))
                PropertyRow(label: "Последняя активность", value: formattedDate(properties.lastSeen))
            }
            
            Section(header: Text("Передача"), footer: Text("Объёмы переданных данных")) {
                PropertyRow(label: "Загружено всего", value: formattedSize(properties.totalDownloaded))
                PropertyRow(label: "Загружено за сессию", value: formattedSize(properties.totalDownloadedSession))
                PropertyRow(label: "Отдано всего", value: formattedSize(properties.totalUploaded))
                PropertyRow(label: "Отдано за сессию", value: formattedSize(properties.totalUploadedSession))
                PropertyRow(label: "Потрачено впустую", value: formattedSize(properties.totalWasted))
            }
            
            Section(header: Text("Дополнительно"), footer: Text("Прочие свойства торрента")) {
                PropertyRow(label: "Коэффициент шаринга", value: String(format: "%.3f", properties.shareRatio))
                PropertyRow(label: "Приватный торрент", value: properties.isPrivate ? "Да" : "Нет")
            }
        }
    }
}
