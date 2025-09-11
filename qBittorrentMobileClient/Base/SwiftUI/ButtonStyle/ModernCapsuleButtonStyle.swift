//
//  ModernCapsuleButtonStyle.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 09.09.2025.
//

import SwiftUI

struct ModernCapsuleButtonStyle: ButtonStyle {
    // Параметры стиля
    enum Style {
        case primary, primaryInverse, secondary, destructive
    }
    
    let style: Style
    let height: CGFloat?
    let maxWidth: CGFloat?
    
    // Цвета и стили для разных состояний
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return .accent
        case .primaryInverse:
            return .backgroundSecond
        case .secondary:
            return .gray
        case .destructive:
            return .red
        }
    }
    
    private var foregroundColor: some ShapeStyle {
        switch style {
        case .primary, .destructive:
            return .white
        case .primaryInverse:
            return .label
        case .secondary:
            return .white
        }
    }
    
    private let cornerRadius: CGFloat = 16
    private let scaleEffect: CGFloat = 0.95
    private let disabledOpacity: Double = 0.5
    private let loadingOpacity: Double = 0.7
    
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.isLoading) private var isLoading
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 8) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(foregroundColor)
                    .scaleEffect(0.8)
            }
            
            configuration.label
                .font(.system(.body, design: .rounded, weight: .medium))
                .foregroundStyle(foregroundColor)
                .opacity(isEnabled ? 1.0 : disabledOpacity)
        }
        .frame(maxWidth: maxWidth)
        .padding()
        .background {
            Capsule()
                .fill(.ultraThinMaterial)
                .overlay(
                    Capsule()
                        .fill(backgroundColor.gradient)
                        .opacity(isEnabled ? 1.0 : disabledOpacity)
                )
        }
        .frame(height: height)
        .scaleEffect(configuration.isPressed ? scaleEffect : 1.0)
        .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == ModernCapsuleButtonStyle {
    static func modernCapsule(_ style: ModernCapsuleButtonStyle.Style = .primary, height: CGFloat? = 44, maxWidth: CGFloat? = nil) -> ModernCapsuleButtonStyle { ModernCapsuleButtonStyle(style: style, height: height, maxWidth: maxWidth) }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var isLoading = true
        
        var body: some View {
            VStack(spacing: 20) {
                // Primary стиль
                Button("Primary Button") {
                    print("Primary button tapped")
                }
                .buttonStyle(.modernCapsule(.primary))
                
                // Primary стиль
                Button("Primary Inverse Button") {
                    print("Primary Inverse button tapped")
                }
                .buttonStyle(.modernCapsule(.primaryInverse))
                
                // Secondary стиль
                Button("Secondary Button") {
                    print("Secondary button tapped")
                }
                .buttonStyle(.modernCapsule(.secondary))
                
                // Destructive стиль
                Button("Destructive Button") {
                    print("Destructive button tapped")
                }
                .buttonStyle(.modernCapsule(.destructive))
                
                // Loading стиль
                Button("Loading Button") {
                    print("Loading button tapped")
                }
                .buttonStyle(.modernCapsule(.primary))
                .loading(isLoading)
                
                // Disabled состояние
                Button("Disabled Button") {
                    print("Disabled button tapped")
                }
                .buttonStyle(.modernCapsule(.primary))
                .disabled(true)
                
                // Длинный текст
                Button("Button with Very Long Text Content") {
                    print("Long text button tapped")
                }
                .buttonStyle(.modernCapsule(.secondary, maxWidth: .infinity))
                
                List {
                    Toggle(isOn: $isLoading) {
                        Text("Loading")
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.background)
        }
    }
    return PreviewWrapper()
}
