//
//  AsyncState.swift
//  Kino Club
//
//  Created by Denis Dmitriev on 11.03.2025.
//

import SwiftUI

public enum AsyncStatePhase {
    case initial
    case loading
    case empty
    case success(Date)
    case failure(Error)
    
    public var isLoading: Bool {
        if case .loading = self {
            return true
        }
        
        return false
    }
    
    public var lastUpdated: Date? {
        if case let .success(date) = self {
            return date
        }
        
        return nil
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
    public func asyncState<InitialContent: View, LoadingContent: View, EmptyContent: View, FailureContent: View>(
        _ phase: AsyncStatePhase,
        initialContent: InitialContent,
        loadingContent: LoadingContent,
        emptyContent: EmptyContent,
        failureContent: (Error) -> FailureContent
    ) -> some View {
        switch phase {
        case .initial:
            initialContent
        case .loading:
            loadingContent
        case .empty:
            emptyContent
        case .success:
            self
        case .failure(let error):
            failureContent(error)
        }
    }
}

@propertyWrapper
public struct AsyncState<Value: Codable>: DynamicProperty {
    @State public var phase: AsyncStatePhase = .initial
    
    @State private var value: Value
    
    public var wrappedValue: Value {
        get { value }
        nonmutating set { value = newValue }
    }
    
    public var isEmpty: Bool {
        if (value as AnyObject) is NSNull {
            return true
        } else if let val = value as? Array<Any>, val.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    public init(wrappedValue value: Value) {
        self._value = State(initialValue: value)
    }
    
    @State private var retryTask: (() async throws -> Value)? = nil
    
    public func fetch(expiration: TimeInterval = 120, task: @escaping () async throws -> Value) async {
        self.retryTask = nil
        
        if !(phase.lastUpdated?.hasExpired(in: expiration) ?? true) {
            return
        }
        
        Task {
            do {
                phase = .loading
                value = try await task()
                if isEmpty {
                    self.retryTask = task
                    phase = .empty
                } else {
                    phase = .success(Date())
                }
            } catch _ as CancellationError {
                // Keep current state (loading)
            } catch {
                self.retryTask = task
                phase = .failure(error)
            }
        }
    }
    
    public func retry() async {
        guard let task = retryTask else { return }
        await fetch(task: task)
    }
    
    public func hasExpired(in interval: TimeInterval) -> Bool {
        phase.lastUpdated?.hasExpired(in: interval) ?? true
    }
    
    public func invalidate() {
        if case .success = phase {
            phase = .success(.distantPast)
        }
    }
}

extension View {
    @ViewBuilder
    public func asyncState<
        T: Codable,
        InitialContent: View,
        LoadingContent: View,
        EmptyContent: View,
        FailureContent: View
    >(
        _ state: AsyncState<T>,
        initialContent: InitialContent,
        loadingContent: LoadingContent,
        emptyContent: EmptyContent,
        failureContent: (Error) -> FailureContent
    ) -> some View {
        asyncState(
            state.phase,
            initialContent: initialContent,
            loadingContent: loadingContent,
            emptyContent: emptyContent,
            failureContent: failureContent
        )
    }
}

public extension Date {
    func hasExpired(in interval: TimeInterval) -> Bool {
        return self.addingTimeInterval(interval) < Date()
    }
}

fileprivate struct Item: Identifiable, Hashable, Codable {
    var id: String { name }
    let name: String
}

fileprivate struct FailureContent: View {
    let error: Error
    let retry: () -> Void
    var body: some View {
        VStack {
            Text("⚠️")
            Text(error.localizedDescription)
            Button("Retry") {
                retry()
            }
        }
    }
}


fileprivate struct PreviewWrapper: View {
    @AsyncState private var items: [Item] = []
    let action: () async throws -> [Item]
    
    init(action: @escaping () async throws -> [Item]) {
        self.action = action
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ForEach(items) { item in
                    Text(item.name)
                }
            }
        }
        .asyncState(
            _items.phase,
            initialContent: ProgressView(),
            loadingContent: ProgressView(),
            emptyContent: ContentUnavailableView(
                "Список пуст",
                systemImage: "list.bullet",
                description: Text("Нет элементов для отображения")
            ),
            failureContent: { error in
                FailureContent(error: error, retry: {})
            }
        )
        .task {
            await _items.fetch {
                return try await action()
            }
        }
    }
}

#Preview("Content") {
    PreviewWrapper {
        [
            Item(name: "Элемент 1"),
            Item(name: "Элемент 2"),
            Item(name: "Элемент 3")
        ]
    }
}

#Preview("Empty") {
    PreviewWrapper { [] }
}

#Preview("Loading") {
    PreviewWrapper {
        try await Task.sleep(for: .seconds(5))
        return []
    }
}

#Preview("Failure") {
    PreviewWrapper {
        let userInfo: [String: Any] = [
            NSLocalizedDescriptionKey: "Network request failed.",
            NSLocalizedRecoverySuggestionErrorKey: "Check your internet connection and try again.",
            "statusCode": 404,
            NSUnderlyingErrorKey: NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        ]
        throw NSError(domain: "com.example.MyApp", code: 404, userInfo: userInfo)
    }
}
