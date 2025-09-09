//
//  TitlePageLabel.swift
//  ShootingDayCalc
//
//  Created by Denis Dmitriev on 13.07.2025.
//

import SwiftUI

struct TitlePageLabel: View {
    @Binding var selection: Int
    let titles: [String]
    
    @State private var titleWidths: [Int: CGFloat] = [:]
    @State private var titleOffsets: [Int: CGFloat] = [:]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: .zero) {
                    ForEach(Array(zip(titles.indices, titles)), id: \.1) { index, title in
                        Button {
                            withAnimation(.spring()) {
                                selection = index
                            }
                        } label: {
                            Text(title)
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                                .lineLimit(1)
                                .font(.headline)
                        }
                        .tint(Color.primary)
                        .background(
                            GeometryReader { geometry in
                                Color.clear
                                    .onAppear {
                                        titleWidths[index] = geometry.size.width
                                        titleOffsets[index] = geometry.frame(in: .global).minX
                                    }
                                    .onChange(of: geometry.size.width) { _, newWidth in
                                        titleWidths[index] = newWidth
                                    }
                                    .onChange(of: geometry.frame(in: .global).minX) { _, newOffset in
                                        titleOffsets[index] = newOffset
                                    }
                            }
                        )
                        .padding(.horizontal, 4)
                    }
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Capsule()
                        .fill(.tint)
                        .frame(width: titleWidths[selection] ?? 0, height: 3)
                        .offset(x: titleOffsets[selection] ?? 0)
                        .animation(.spring(), value: selection)
                }
            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var selection: Int = 0
        @State private var colors: [Color] = [.red, .green, .yellow]
        
        private let titles: [String] = ["Red", "Green", "Yellow"]
        
        var body: some View {
            TabView(selection: $selection.animation()) {
                ForEach(Array(zip(colors.indices, colors)), id: \.1) { index, color in
                    color
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .overlay(alignment: .top) {
                TitlePageLabel(
                    selection: $selection,
                    titles: titles
                )
                .padding(.top)
            }
        }
    }
    
    return PreviewWrapper()
}
