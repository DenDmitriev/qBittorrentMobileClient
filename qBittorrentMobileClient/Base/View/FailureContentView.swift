//
//  FailureContentView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 09.09.2025.
//

import SwiftUI

struct FailureContentView: View {
    let error: Error
    let retry: () -> Void
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .foregroundStyle(.red.gradient)
                
                Text("Something Went Wrong")
                    .font(.system(.title2, weight: .semibold))
                    .foregroundStyle(.primary)
                
                Text(error.localizedDescription)
                    .font(.system(.subheadline))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                // Кнопка повтора
                Button(action: retry) {
                    Text("Try Again")
                }
                .buttonStyle(.modernCapsule(.primary))
                .padding(.top, 8)
            }
            .padding(.vertical, 24)
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
}

#Preview {
    let error = NSError(
        domain: "com.example.MyApp",
        code: 404,
        userInfo: [
            NSLocalizedDescriptionKey: "Network request failed.",
            NSLocalizedRecoverySuggestionErrorKey: "Check your internet connection and try again.",
            "statusCode": 404,
            NSUnderlyingErrorKey: NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        ]
    )
    FailureContentView(error: error, retry: {})
}
