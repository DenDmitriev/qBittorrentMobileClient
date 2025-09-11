//
//  ToastItem.swift
//  Barcelona
//
//  Created by Denis Dmitriev on 10.03.2025.
//

import SwiftUI

struct Toast: Hashable {
    enum ToastType: Hashable {
        case info, error, success
    }
    enum Icon: Hashable {
        case system(String)
        case custom(String)
    }
    
    var type: ToastType
    var title: String?
    var text: String
    var actionTitle: String?
    var icon: Icon?
    var onAction: (() -> Void)?
    var color: Color {
        switch type {
        case .info:
            return .backgroundBlue
        case .error:
            return .backgroundRed
        case .success:
            return .backgroundGreen
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(title)
        hasher.combine(text)
        hasher.combine(actionTitle)
        hasher.combine(icon)
    }
    
    static func == (lhs: Toast, rhs: Toast) -> Bool {
        return lhs.type == rhs.type
        && lhs.title == rhs.title
        && lhs.text == rhs.text
        && lhs.actionTitle == rhs.actionTitle
        && lhs.icon == rhs.icon
        && (lhs.onAction == nil && rhs.onAction == nil)
    }
}
