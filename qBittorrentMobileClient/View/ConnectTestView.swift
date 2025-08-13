//
//  ConnectTestView.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 13.08.2025.
//

import SwiftUI

struct ConnectTestView: View {
    @State private var result: String = ""
    @State private var error: ServerError?
    let authRepository = AuthRepository()
    
    var body: some View {
        VStack {
            Text(result)
            Button("Получить данные") {
                fetchDataFromLocalNetwork()
            }
            if let error {
                VStack {
                    Text(error.details.statusCode?.formatted() ?? "")
                    Text(error.title)
                    Text(error.details.message)
                }
                .foregroundStyle(.red)
            }
        }
    }
    
    private func getData() {
        error = nil
        Task {
            do {
                try await authRepository.authorizeUser(login: "admin", password: "adminadmin")
            } catch let error as ServerError {
                print(error.localizedDescription)
                Task { @MainActor in
                    self.error = error
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchDataFromLocalNetwork() {
        guard let url = URL(string: "http://mediaserver.local:8080") else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Ошибка: \(error.localizedDescription)")
                return
            }
            guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                print("Данные не получены")
                return
            }
            print("Ответ от сервера: \(responseString)")
        }
        
        task.resume()
    }
}

#Preview {
    ConnectTestView()
}
