//
//  StateFlow.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 14.08.2025.
//

import SwiftUI
import Combine

@propertyWrapper
final class StateFlow<T: Codable & Hashable & Sendable>: ObservableObject {
    @Published var wrappedValue: T?
    @Published private var error: Error?
    
    var projectedValue: Published<T?>.Publisher { $wrappedValue }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    private var task: Task<Void, Never>?
    private var fetch: (() async throws -> T)?
    private var isFlowPaused: Bool = false
    
    init(value: T? = nil) {
        wrappedValue = value
        startStateFlow()
    }
    
    func setFetch(_ fetch: @escaping () async throws -> T) {
        self.fetch = fetch
    }
    
    func pauseFlow() {
        isFlowPaused = true
    }
    
    func resumeFlow() {
        isFlowPaused = false
    }
    
    private func startStateFlow() {
        task = Task {
            while !Task.isCancelled {
                guard !isFlowPaused, let fetch else {
                    try? await Task.sleep(for: .seconds(1))
                    continue
                }
                
                do {
                    let newValue = try await fetch()
                    
                    await MainActor.run {
                        if wrappedValue != newValue {
                            wrappedValue = newValue
                            error = nil
                        }
                    }
                } catch {
                    await MainActor.run {
                        self.error = error
                    }
                }
                
                try? await Task.sleep(for: .seconds(1))  // Задержка 1 секунда
            }
        }
    }
    
    deinit {
        task?.cancel()
    }
}
