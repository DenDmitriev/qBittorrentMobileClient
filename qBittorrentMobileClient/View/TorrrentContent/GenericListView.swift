//
//  GenericListView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 03.09.2025.
//

import SwiftUI

// Enum для состояний списка
enum ListState<T> {
    case idle
    case loading
    case loaded([T])
    case empty
    case error(Error)
}

// Переиспользуемое представление для списка
struct GenericListView<T: Hashable & Identifiable, Content: View, EmptyContent: View, LoadingContent: View>: View {
    @Binding var state: ListState<T>
    let retryAction: () -> Void
    let content: (T) -> Content
    let emptyContent: () -> EmptyContent
    let loadingContent: () -> LoadingContent
    
    init(
        state: Binding<ListState<T>>,
        retryAction: @escaping () -> Void,
        @ViewBuilder content: @escaping (T) -> Content,
        @ViewBuilder emptyContent: @escaping () -> EmptyContent,
        @ViewBuilder loadingContent: @escaping () -> LoadingContent
    ) {
        self._state = state
        self.retryAction = retryAction
        self.content = content
        self.emptyContent = emptyContent
        self.loadingContent = loadingContent
    }
    
    var body: some View {
        switch state {
        case .idle:
            Color.clear
        case .loading:
            loadingContent()
        case .loaded(let items):
            if items.isEmpty {
                emptyContent()
            } else {
                List(items) { item in
                    content(item)
                }
            }
        case .empty:
            emptyContent()
        case .error(let error):
            VStack(spacing: 16) {
                ContentUnavailableView(
                    "Ошибка",
                    systemImage: "exclamationmark.triangle",
                    description: Text(error.localizedDescription)
                )
                Button("Повторить") {
                    retryAction()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}

// Пример использования
#Preview {
    struct Item: Identifiable, Hashable {
        let id = UUID()
        let name: String
    }
    
    struct PreviewWrapper: View {
        @State var state: ListState<Item>
        
        var body: some View {
            GenericListView(
                state: $state,
                retryAction: {
                    print("Retry tapped")
                },
                content: { item in
                    Text(item.name)
                },
                emptyContent: {
                    ContentUnavailableView(
                        "Список пуст",
                        systemImage: "list.bullet",
                        description: Text("Нет элементов для отображения")
                    )
                },
                loadingContent: {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            )
        }
    }
    return VStack {
        PreviewWrapper(state: .idle)
        PreviewWrapper(state: .loaded([Item(name: "Элемент 1"), Item(name: "Элемент 2")]))
        PreviewWrapper(state: .empty)
        PreviewWrapper(state: .loading)
        PreviewWrapper(state: .error(NSError(domain: "", code: 0, userInfo: nil)))
    }
}
