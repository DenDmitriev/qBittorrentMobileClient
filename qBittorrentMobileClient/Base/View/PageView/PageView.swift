//
//  PageView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 13.07.2025.
//

import SwiftUI

protocol Titleable {
    var title: String { get }
}

struct PageView<Page: Hashable & Identifiable & Titleable, PageContent: View>: View {
    @Binding var selected: Page.ID?
    @Binding var pages: [Page]
    let content: () -> PageContent
    
    init(
        selected: Binding<Page.ID?>,
        pages: Binding<[Page]>,
        content: @escaping () -> PageContent
    ) {
        self._selected = selected
        self._pages = pages
        self.content = content
    }
    
    var body: some View {
        VStack(spacing: 0) {
            let selectionIndex = Binding(
                get: { pages.firstIndex(where: { $0.id == selected }) ?? 0 },
                set: { index in
                    if pages.indices.contains(index) {
                        selected = pages[index].id
                    } else {
                        selected = pages.first?.id
                    }
                }
            )
            TitlePageLabel(
                selection: selectionIndex,
                titles: pages.map({ $0.title })
            )
            .padding(.top, 8)
            
            TabView(selection: $selected) {
                content()
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut, value: selected)
        }
    }
}

fileprivate enum Flavor: String, CaseIterable, Identifiable, Titleable {
    case chocolate, vanilla, strawberry
    var id: Self { self }
    var title: String { rawValue.capitalized }
    var color: Color {
        switch self {
        case .chocolate:
            return .init(red: 0.47, green: 0.24, blue: 0.13)
        case .vanilla:
            return .init(red: 1, green: 0.92, blue: 0.81)
        case .strawberry:
            return .red
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var selectedFlavor: Flavor.ID? = .chocolate
        @State private var flowers: [Flavor] = [.chocolate, .vanilla, .strawberry]
        
        var body: some View {
            PageView(selected: $selectedFlavor, pages: $flowers) {
                ForEach(Flavor.allCases) { flower in
                    ZStack {
                        flower.color
                        Text(flower.title)
                    }
                    .tag(flower.id)
                }
            }
        }
    }
    return PreviewWrapper()
}
