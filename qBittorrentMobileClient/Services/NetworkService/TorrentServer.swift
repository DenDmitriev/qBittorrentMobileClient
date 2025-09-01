//
//  TorrentServer.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 01.09.2025.
//

import Foundation

protocol TorrentServer {
    var serverURL: URL { get }
}

extension TorrentServer {
    // private func getBaseURL() -> URL { URL(string: "http://10.147.20.215:8080")! }
    
    var serverURL: URL {
        UserDefaults.standard.url(forKey: AppStorageKeys.serverUrl) ?? URL(string: "http://0.0.0.0:8080/")!
    }
}
