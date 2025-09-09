//
//  SortMenu.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 09.09.2025.
//

import SwiftUI

struct SortMenu: View {
    @Binding var sort: TorrentSort
    @Binding var sortDirection: SortDirection
    
    var body: some View {
        Menu {
            Section("Sort By") {
                ForEach(TorrentSort.allCases) { sortOption in
                    Button {
                        sort = sortOption
                    } label: {
                        if sort == sortOption {
                            Label(sortOption.title, systemImage: "checkmark")
                        } else {
                            Text(sortOption.title)
                        }
                    }
                }
            }
            Section("Direction") {
                ForEach(SortDirection.allCases) { direction in
                    Button {
                        sortDirection = direction
                    } label: {
                        Label(direction.title, systemImage: sortDirection == direction ? direction.selectedSystemImage : direction.systemImage)
                    }
                }
            }
        } label: {
            Label("Sort", systemImage: sortDirection.systemImage)
        }
    }
}

#Preview {
    SortMenu(sort: .constant(.name), sortDirection: .constant(.ascending))
}
