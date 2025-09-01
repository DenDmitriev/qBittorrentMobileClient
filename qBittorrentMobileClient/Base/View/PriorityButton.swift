//
//  PriorityButton.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 30.08.2025.
//

import SwiftUI

struct PriorityButton: View {
    let progress: Double
    let priority: TorrentPriority
    var action: (TorrentPriority) -> Void
    
    var body: some View {
        ZStack {
            CircularProgressView(progress: progress)
                .environment(\.tintColor, colorForPriority)
            
            Button {
                switch priority {
                case .doNotDownload:
                    action(.normal)
                case .normal:
                    action(.high)
                case .high:
                    action(.maximal)
                case .maximal:
                    action(.doNotDownload)
                }
            } label: {
                iconForState
            }
            .font(.system(size: 24, weight: .black))
        }
        .frame(width: 60, height: 60)
    }
    
    private var colorForPriority: Color {
        switch priority {
        case .doNotDownload:
            return .gray
        case .normal, .high, .maximal:
            return .blue
        }
    }
    
    @ViewBuilder
    private var iconForState: some View {
        switch priority {
        case .doNotDownload:
            Circle()
                .stroke(colorForPriority, lineWidth: 2)
                .frame(height: 10)
        case .normal:
            Circle()
                .fill(.blue)
                .frame(height: 10)
        case .high:
            HStack(spacing: 2) {
                ForEach(1...2, id: \.self) { _ in
                    Circle()
                        .fill(colorForPriority)
                        .frame(height: 10)
                }
            }
        case .maximal:
            HStack(spacing: 2) {
                ForEach(1...3, id: \.self) { _ in
                    Circle()
                        .fill(colorForPriority)
                        .frame(height: 10)
                }
            }
        }
    }
}

#Preview {
    PriorityButton(progress: 0.33, priority: .doNotDownload, action: { _ in })
    PriorityButton(progress: 0.25, priority: .normal, action: { _ in })
    PriorityButton(progress: 0.5, priority: .high, action: { _ in })
    PriorityButton(progress: 0.75, priority: .maximal, action: { _ in })
}
