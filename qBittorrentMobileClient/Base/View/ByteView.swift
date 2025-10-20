//
//  ByteView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 19.08.2025.
//

import SwiftUI

enum ByteItem {
    case size(Int)
    case speed(Int)
}

class FileSizeFormatterUtil {
    // Форматтер для размера файлов
    static let sizeFormatter: ByteCountFormatter = {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB, .useTB]
        formatter.countStyle = .file
        formatter.allowsNonnumericFormatting = false
        return formatter
    }()
    
    // Форматтер для скорости скачивания
    static let speedFormatter: ByteCountFormatter = {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .binary
        formatter.allowsNonnumericFormatting = false
        return formatter
    }()
    
    // Форматирование размера файла
    static func formatFileSize(_ bytes: Int64) -> String {
        sizeFormatter.string(fromByteCount: bytes)
    }
    
    // Форматирование скорости скачивания (байт/с)
    static func formatDownloadSpeed(_ bytesPerSecond: Int64) -> String {
        "\(speedFormatter.string(fromByteCount: bytesPerSecond))/s"
    }
    
    // Форматирование размера файла с указанием единицы измерения
    static func formatFileSizeWithUnit(_ bytes: Int64) -> (value: String, unit: String) {
        let formatted = sizeFormatter.string(fromByteCount: bytes)
        let components = formatted.components(separatedBy: " ")
        return (components.first ?? "0", components.last ?? "B")
    }
    
    // Форматирование скорости с указанием единицы измерения
    static func formatSpeedWithUnit(_ bytesPerSecond: Int64) -> (value: String, unit: String) {
        let formatted = speedFormatter.string(fromByteCount: bytesPerSecond)
        let components = formatted.components(separatedBy: " ")
        return (components.first ?? "0", components.last ?? "B/s")
    }
}

struct ByteView<Icon: View>: View {
    let item: ByteItem
    let icon: (() -> Icon)?
    
    init(item: ByteItem, icon: @escaping () -> Icon) {
        self.item = item
        self.icon = icon
    }
    
    init(item: ByteItem) where Icon == EmptyView {
        self.item = item
        self.icon = nil
    }
    
    var body: some View {
        HStack(spacing: 4) {
            switch item {
            case .size(let size):
                let (value, unit) = FileSizeFormatterUtil.formatFileSizeWithUnit(Int64(size))
                HStack(alignment: .lastTextBaseline, spacing: 2) {
                    Text(value)
                        .font(.system(.body))
                    Text(unit)
                        .font(.system(.caption))
                }
            case .speed(let speed):
                let (value, unit) = FileSizeFormatterUtil.formatSpeedWithUnit(Int64(speed))
                HStack(alignment: .lastTextBaseline, spacing: 2) {
                    Text(value)
                        .font(.system(.body))
                    Text("\(unit)/s")
                        .font(.system(.caption))
                }
            }
            if let icon {
                icon()
            }
        }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 8) {
        ByteView(item: .size(37627101184)) // ~37.6 GB
        ByteView(item: .speed(1024)) // 1 KB/s
        ByteView(item: .size(1536)) // 1.5 KB
        ByteView(item: .speed(1234567)) // ~1.2 MB/s
        ByteView(item: .size(1234567890123)) // ~1.2 TB
        ByteView(item: .speed(0)) // 0 B/s
    }
    .padding()
}
