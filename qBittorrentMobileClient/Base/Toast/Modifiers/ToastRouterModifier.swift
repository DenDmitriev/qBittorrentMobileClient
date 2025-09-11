//
//  ToastRouterModifier.swift
//  Kino Club
//
//  Created by Denis Dmitriev on 25.02.2025.
//

import SwiftUI

struct ToastRouterModifier<ToastContent: View>: ViewModifier {
    let toastContent: (Toast) -> ToastContent
    @Environment(ToastRouter.self) private var toastRouter
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if toastRouter.isShowing, let item = toastRouter.item {
                    toastContent(item)
                        .padding(.bottom, 20)
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom),
                            removal: .move(edge: .bottom).combined(with: .opacity)
                        ))
                }
            }
            .animation(.easeInOut, value: toastRouter.isShowing)
    }
}

extension View {
    func addToast<ToastContent: View>(content: @escaping (Toast) -> ToastContent) -> some View {
        self.modifier(ToastRouterModifier(toastContent: content))
    }
}
