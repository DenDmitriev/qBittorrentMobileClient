//
//  ToastGlobalValueModifier.swift
//  iosApp
//
//  Created by Denis Dmitriev on 03.04.2025.
//

import SwiftUI

struct ToastGlobalValueModifier: ViewModifier {
    @Binding var toast: Toast?
    let duration: TimeInterval
    
    @Environment(ToastRouter.self) private var toastRouter
    @State private var isPresented: Bool = false
    
    func body(content: Content) -> some View {
        content
            .onChange(of: toast) { _, newValue in
                if newValue != nil {
                    isPresented = true
                } else {
                    isPresented = false
                    toast = nil
                }
            }
            .onChange(of: isPresented) { _, newIsPresented in
                if newIsPresented {
                    toastRouter.showToast(item: toast, duration: duration)
                } else {
                    toastRouter.dismissToast()
                }
            }
            .onChange(of: toastRouter.isShowing) { _, isShowing in
                if isShowing == false {
                    toast = nil
                }
            }
    }
}

struct ToastGlobalErrorValueModifier<Failure: Hashable & LocalizedError>: ViewModifier {
    @Binding var error: Failure?
    let duration: TimeInterval
    
    @Environment(ToastRouter.self) private var toastRouter
    @State private var isPresented: Bool = false
    
    func body(content: Content) -> some View {
        content
            .onChange(of: error) { _, newValue in
                if newValue != nil {
                    isPresented = true
                } else {
                    isPresented = false
                    error = nil
                }
            }
            .onChange(of: isPresented) {
                _,
                newIsPresented in
                if newIsPresented {
                    let toast = Toast(
                        type: .error,
                        text: error?.localizedDescription ?? String(localized: "Unknown error"),
                        icon: .system("exclamationmark.triangle")
                    )
                    toastRouter.showToast(item: toast, duration: duration)
                } else {
                    toastRouter.dismissToast()
                }
            }
            .onChange(of: toastRouter.isShowing) { _, isShowing in
                if isShowing == false {
                    error = nil
                }
            }
    }
}

extension View {
    func toast(toast: Binding<Toast?>, duration: TimeInterval = 3) -> some View {
        self.modifier(ToastGlobalValueModifier(toast: toast, duration: duration))
    }
    
    func toast<Failure: Hashable & LocalizedError>(error: Binding<Failure?>, duration: TimeInterval = 3) -> some View {
        self.modifier(ToastGlobalErrorValueModifier(error: error, duration: duration))
    }
}
