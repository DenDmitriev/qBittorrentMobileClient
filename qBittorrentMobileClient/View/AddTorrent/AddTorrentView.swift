//
//  AddTorrentView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 27.08.2025.
//

import SwiftUI
import UniformTypeIdentifiers

enum AddTorrentError: LocalizedError {
    case urlInvalid
    case requestFailure(description: String)
    
    var errorDescription: String? {
        switch self {
        case .urlInvalid:
            return String(localized: "URL is not correct")
        case .requestFailure(let description):
            return description
        }
    }
}

struct AddTorrentView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(TorrentRepository.self) private var torrentRepository
    @State private var showingDocumentPicker = false
    @State private var torrentUrlString: String = ""
    @State private var torrentFileUrl: URL?
    @State private var isPaused = false
    @State private var isLoadSequentially = true
    @State private var dlLimitString: String = ""
    @State private var upLimitString: String = ""
    @State private var error: LocalizedError?
    
    private var isAddTorrentButtonDisable: Bool {
        torrentUrlString.isEmpty && torrentFileUrl == nil
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        HStack {
                            Image(systemName: "link")
                                .foregroundStyle(.secondary)
                            TextField("Torrent URL or Magnet Link", text: $torrentUrlString)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                            Button {
                                if let string = UIPasteboard.general.string {
                                    torrentUrlString = string
                                }
                            } label: {
                                Image(systemName: "document.on.clipboard.fill")
                            }
                            .foregroundStyle(.green)
                        }
                    } header: {
                        Text("Add from URL")
                            .font(.headline)
                    } footer: {
                        if let error {
                            Text(error.localizedDescription)
                                .foregroundStyle(.red)
                                .font(.footnote)
                        }
                    }
                    
                    Section {
                        Button() {
                            showingDocumentPicker = true
                        } label: {
                            if let torrentFileUrl {
                                Text(torrentFileUrl.lastPathComponent)
                            } else {
                                Text("Select Torrent File")
                            }
                        }
                        .buttonStyle(.modernCapsule(.secondary, maxWidth: .infinity))
                    } header: {
                        Text("Add from File")
                            .font(.headline)
                    }
                    
                    Section {
                        Toggle("Start Paused", isOn: $isPaused)
                        Toggle("Sequential Download", isOn: $isLoadSequentially)
                    } header: {
                        Text("Torrent Options")
                            .font(.headline)
                    }
                    
                    Section {
                        HStack {
                            Image(systemName: "arrow.down")
                                .foregroundStyle(.green)
                            TextField("Download Limit (KB/s)", text: $dlLimitString)
                                .keyboardType(.numberPad)
                        }
                        HStack {
                            Image(systemName: "arrow.up")
                                .foregroundStyle(.blue)
                            TextField("Upload Limit (KB/s)", text: $upLimitString)
                                .keyboardType(.numberPad)
                        }
                    } header: {
                        Text("Speed Limits")
                            .font(.headline)
                    } footer: {
                        Text("Leave empty for no limit. Values must be positive integers.")
                            .font(.footnote)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Add Torrent")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("Add Torrent", action: handleAddTorrent)
                        .buttonStyle(.modernCapsule(.primary, maxWidth: .infinity))
                        .disabled(isAddTorrentButtonDisable)
                }
            }
            .sheet(isPresented: $showingDocumentPicker) {
                DocumentPicker(contentTypes: [UTType(filenameExtension: "torrent")!]) { url in
                    torrentUrlString = ""
                    torrentFileUrl = url
                }
            }
        }
    }
    
    private func handleAddTorrent() {
        if let torrentUrl = URL(string: torrentUrlString) {
            addTorrentUrl(torrentUrl)
        } else if let fileUrl = torrentFileUrl {
            addTorrentFile(fileUrl)
        } else {
            error = AddTorrentError.urlInvalid
        }
    }
    
    private func addTorrentUrl(_ url: URL) {
        let dlLimit = Int((Double(dlLimitString) ?? 0) * 1024)
        let upLimit = Int((Double(upLimitString) ?? 0) * 1024)
        
        error = nil
        Task {
            do {
                try await torrentRepository.addTorrent(
                    url: url,
                    paused: isPaused,
                    loadSequentially: isLoadSequentially,
                    downloadLimit: dlLimit > 0 ? dlLimit : nil,
                    uploadLimit: upLimit > 0 ? upLimit : nil
                )
                dismiss()
            } catch let error as ServerError {
                await MainActor.run {
                    self.error = AddTorrentError.requestFailure(description: error.details.message)
                }
            } catch {
                await MainActor.run {
                    self.error = AddTorrentError.requestFailure(description: error.localizedDescription)
                }
            }
        }
    }
    
    private func addTorrentFile(_ url: URL) {
        guard url.pathExtension.lowercased() == "torrent" else {
            error = AddTorrentError.requestFailure(description: "Selected file is not a .torrent file")
            return
        }
        
        let dlLimit = Int((Double(dlLimitString) ?? 0) * 1024)
        let upLimit = Int((Double(upLimitString) ?? 0) * 1024)
        
        error = nil
        Task {
            do {
                try await torrentRepository.addTorrent(
                    file: url,
                    paused: isPaused,
                    loadSequentially: isLoadSequentially,
                    downloadLimit: dlLimit > 0 ? dlLimit : nil,
                    uploadLimit: upLimit > 0 ? upLimit : nil
                )
                dismiss()
            } catch let error as ServerError {
                await MainActor.run {
                    self.error = AddTorrentError.requestFailure(description: error.details.message)
                }
            } catch {
                await MainActor.run {
                    self.error = AddTorrentError.requestFailure(description: error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    AddTorrentView()
        .environment(TorrentRepository())
}
