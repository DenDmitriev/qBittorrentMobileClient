//
//  LoadingKey.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 09.09.2025.
//

import SwiftUI

struct IsLoadingKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var isLoading: Bool {
        get { self[IsLoadingKey.self] }
        set { self[IsLoadingKey.self] = newValue }
    }
}

struct LoadingModifier: ViewModifier {
    let isLoading: Bool

    func body(content: Content) -> some View {
        content
            .environment(\.isLoading, isLoading)
            .disabled(isLoading)
    }
}

extension View {
    func loading(_ isLoading: Bool) -> some View {
        modifier(LoadingModifier(isLoading: isLoading))
    }
}

fileprivate struct ChildView: View {
    @Environment(\.isLoading) private var isLoading

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
            } else {
                Text("Content Loaded")
            }
            Button("Toggle Loading") {
                // Для демонстрации можно переключать значение в родительском компоненте
            }
        }
    }
}

fileprivate struct ParentView: View {
    @State private var isLoading = false

    var body: some View {
        ChildView()
            .loading(isLoading)
            .onAppear {
                // Симуляция загрузки
                isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isLoading = false
                }
            }
    }
}

#Preview {
    ParentView()
}
