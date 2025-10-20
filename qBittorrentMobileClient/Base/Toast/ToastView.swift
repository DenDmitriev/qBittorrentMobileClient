//
//  ToastView.swift
//  Kino Club
//
//  Created by Denis Dmitriev on 25.02.2025.
//

import SwiftUI

struct ToastView: View {
    @Environment(ToastRouter.self) private var toastRouter
    
    let item: Toast
    
    var body: some View {
        Group {
            HStack(spacing: 10) {
                if let icon = item.icon {
                    getIcon(icon: icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                }
                VStack(alignment: .leading, spacing: 4) {
                    if let title = item.title {
                        Text(title)
                            .font(.system(size: 17).weight(.semibold))
                            .lineLimit(1)
                    }
                    Text(item.text)
                        .font(.caption)
                        .lineLimit(3)
                        .minimumScaleFactor(0.5)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if let actionTitle = item.actionTitle {
                    Button(actionTitle) {
                        item.onAction?()
                    }
                    .foregroundColor(.green)
                    .font(.body.bold())
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .background(item.color)
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .padding(.bottom, 60)
    }
    
    private func getIcon(icon: Toast.Icon) -> Image {
        switch icon {
        case .system(let systemName):
            Image(systemName: systemName)
        case .custom(let resourceName):
            Image(resourceName)
        }
    }
}

#Preview {
    VStack {
        ToastView(item: .init(
            type: .info,
            title: "Info",
            text: "Some text",
            icon: .system("info.circle"),
            onAction: nil
        ))
        ToastView(item: .init(
            type: .error,
            title: "Error",
            text: "Some text",
            icon: .system("exclamationmark.circle"),
            onAction: nil
        ))
        ToastView(item: .init(
            type: .success,
            title: "Success",
            text: "Some text",
            icon: .system("checkmark.circle"),
            onAction: nil
        ))
    }
    .environment(ToastRouter())
}
