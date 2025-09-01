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
    @State private var isPaused = false
    @State private var isLoadSequentially = true
    @State private var error: LocalizedError?
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Torrent URL", text: $torrentUrlString)
                } footer: {
                    if let error {
                        Text(error.localizedDescription)
                            .foregroundStyle(.red)
                    }
                }
                Section {
                    Button("Select .torrent File") {
                        showingDocumentPicker = true
                    }
                }
                
                Toggle("Pause Torrent", isOn: $isPaused)
                Toggle("Load Sequentially", isOn: $isLoadSequentially)
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("Add", action: addTorrentUrl)
                        .buttonStyle(.borderedProminent)
                }
            }
            .sheet(isPresented: $showingDocumentPicker) {
                DocumentPicker(contentTypes: [UTType(filenameExtension: "torrent")!]) { url in
                    addTorrentFile(url: url)
                }
            }
        }
    }
    
    private func addTorrentUrl() {
        guard let url = URL(string: torrentUrlString) else {
            error = AddTorrentError.urlInvalid
            return
        }
        
        error = nil
        Task {
            do {
                try await torrentRepository.addTorrent(url: url, paused: isPaused, loadSequentially: isLoadSequentially)
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
    
    private func addTorrentFile(url: URL) {
        guard url.pathExtension.lowercased() == "torrent" else {
            error = AddTorrentError.requestFailure(description: "Selected file is not a .torrent file")
            return
        }
        
        error = nil
        Task {
            do {
                try await torrentRepository.addTorrent(file: url, paused: isPaused, loadSequentially: isLoadSequentially)
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
