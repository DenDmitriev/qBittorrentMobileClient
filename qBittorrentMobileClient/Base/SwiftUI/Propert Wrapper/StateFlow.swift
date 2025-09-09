//
//  StateFlow.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 14.08.2025.
//

import SwiftUI
import Combine

enum StateFlowPhase {
    case initial
    case loading
    case empty
    case success
    case failure(Error)
    
    public var isLoading: Bool {
        if case .loading = self {
            return true
        }
        
        return false
    }
    
    public var error: Error? {
        if case let .failure(error) = self {
            return error
        }
        
        return nil
    }
}

extension View {
    @ViewBuilder
    func stateFlow<LoadingContent: View, EmptyContent: View, FailureContent: View>(
        _ phase: StateFlowPhase,
        loadingContent: () -> LoadingContent,
        emptyContent: () -> EmptyContent,
        failureContent: (Error) -> FailureContent
    ) -> some View {
        switch phase {
        case .initial, .loading:
            loadingContent()
        case .empty:
            emptyContent()
        case .success:
            self
        case .failure(let error):
            failureContent(error)
        }
    }
}

@propertyWrapper
struct StateFlow<T: Codable & Hashable & Sendable>: DynamicProperty {
    @State var value: T?
    @State var phase: StateFlowPhase = .initial
    @State var error: Error?
    
    var wrappedValue: T? {
        get { value }
        set { value = newValue }
    }
    
    @State private var task: Task<Void, Never>?
    @State private var fetch: (() async throws -> T)?
    @State private var isFlowPaused: Bool = false
    
    var isEmpty: Bool {
        if (value as AnyObject) is NSNull {
            return true
        } else if let val = value as? Array<Any>, val.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    init(value: T? = nil) {
        self.value = value
    }
    
    init(value: T) {
        self.value = value
    }
    
    func setFetch(_ fetch: @escaping () async throws -> T) {
        invalidate()
        isFlowPaused = false
        self.fetch = fetch
        startStateFlow()
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
                    if value == nil || isEmpty {
                        phase = .loading
                    }
                    let newValue = try await fetch()
                    
                    await MainActor.run {
                        if value != newValue {
                            value = newValue
                            error = nil
                        }
                        if isEmpty {
                            phase = .empty
                            pauseFlow()
                        } else {
                            phase = .success
                        }
                    }
                } catch {
                    await MainActor.run {
                        phase = .failure(error)
                        self.error = error
                        pauseFlow()
                    }
                }
                
                try? await Task.sleep(for: .seconds(1))
            }
        }
    }
    
    func retry() {
        guard isFlowPaused else {
            return
        }
        resumeFlow()
    }
    
    func invalidate() {
        task?.cancel()
    }
}
