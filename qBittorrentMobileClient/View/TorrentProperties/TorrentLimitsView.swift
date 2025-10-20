//
//  TorrentLimitsView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 12.09.2025.
//

import SwiftUI

struct TorrentLimitsView: View {
    private enum Field {
        case dlLimit, upLimit
    }
    private enum LimitType {
        case download, upload
    }
    
    let properties: TorrentGenericProperties
    
    init(properties: TorrentGenericProperties) {
        self.properties = properties
        self.dlLimitString = properties.dlLimit > 0 ? String(properties.dlLimit / 1024) : ""
        self.upLimitString = properties.upLimit > 0 ? String(properties.upLimit / 1024) : ""
    }
    
    @Environment(TorrentRepository.self) private var torrentRepository
    @State private var dlLimitString: String
    @State private var upLimitString: String
    @FocusState private var focusedField: Field?
    @State private var debounceTask: Task<Void, Never>?
    
    var body: some View {
        List {
            Section(header: Text("Limits")) {
                HStack {
                    Image(systemName: "arrow.down")
                        .foregroundStyle(.green)
                    TextField("Download Limit (KB/s)", text: $dlLimitString)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .dlLimit)
                    Text("\(properties.dlSpeed / 1024) KB/s")
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Image(systemName: "arrow.up")
                        .foregroundStyle(.blue)
                    TextField("Upload Limit (KB/s)", text: $upLimitString)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .upLimit)
                    Text("\(properties.upSpeed / 1024) KB/s")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .onTapGesture {
            focusedField = nil
        }
        .onChange(of: dlLimitString) { _, limit in
            debounceSetLimit(limit, type: .download)
        }
        .onChange(of: upLimitString) { _, limit in
            debounceSetLimit(limit, type: .upload)
        }
    }
    
    private func debounceSetLimit(_ limit: String, type: LimitType) {
        debounceTask?.cancel()
        
        debounceTask = Task {
            try? await Task.sleep(for: .seconds(0.5)) // 0.5 seconds debounce
            
            guard !Task.isCancelled else {
                return
            }
            
            let value = Int((Double(limit) ?? 0) * 1024)
            
            do {
                switch type {
                case .download:
                    try await torrentRepository.setDownloadLimit(torrentId: properties.id, limit: value)
                case .upload:
                    try await torrentRepository.setUploadLimit(torrentId: properties.id, limit: value)
                }
            } catch {
                print("Error setting limit: \(error)")
            }
        }
    }
}

#Preview {
    TorrentLimitsView(properties: .placeholder)
        .environment(TorrentRepository())
}
