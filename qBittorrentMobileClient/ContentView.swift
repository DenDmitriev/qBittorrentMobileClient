//
//  ContentView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 13.08.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var isAuthorizationPresented: Bool = true
    
    var body: some View {
        ConnectTestView()
            .sheet(isPresented: $isAuthorizationPresented) {
                AuthView(isPresented: $isAuthorizationPresented)
            }
    }
}

#Preview {
    ContentView()
}
