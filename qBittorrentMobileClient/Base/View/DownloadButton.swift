//
//  DownloadButton.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 21.08.2025.
//

import SwiftUI

enum TorrentAction {
    case pause
    case resume
    case forceStart
    case recheck
}

struct DownloadButton: View {
    let progress: Double
    let state: TorrentState
    var action: (TorrentAction) -> Void
    
    var body: some View {
        ZStack {
            CircularProgressView(progress: progress)
                .environment(\.tintColor, colorForState)
            
            Button {
                switch state {
                case .downloading:
                    action(.pause)
                case .paused:
                    action(.resume)
                case .queued:
                    action(.forceStart)
                case .checking, .allocating, .moving:
                    // Нет действия, процессы автоматические
                    break
                case .seeding:
                    action(.pause)
                case .pausedSeeding:
                    action(.resume)
                case .error, .missingFiles:
                    action(.recheck)
                case .unknown:
                    // Нет действия для неизвестного состояния
                    break
                }
            } label: {
                Image(systemName: iconForState)
                    .foregroundColor(colorForState)
            }
            .font(.system(size: 24, weight: .black))
            .disabled(isButtonDisabled)
        }
        .frame(width: 60, height: 60)
    }
    
    private var iconForState: String {
        switch state {
        case .downloading:
            return "arrow.down.circle.fill"
        case .paused:
            return "play.circle.fill"
        case .queued:
            return "clock.fill"
        case .checking:
            return "arrow.trianglehead.2.clockwise.rotate.90.circle.fill"
        case .seeding:
            return "arrow.up.circle.fill"
        case .pausedSeeding:
            return "checkmark.circle.fill"
        case .error:
            return "exclamationmark.triangle.fill"
        case .missingFiles:
            return "exclamationmark.circle.fill"
        case .allocating:
            return "gearshape.fill"
        case .moving:
            return "arrow.triangle.2.circlepath"
        case .unknown:
            return "questionmark.circle.fill"
        }
    }
    
    private var colorForState: Color {
        switch state {
        case .downloading:
            return .blue // Активная загрузка
        case .paused:
            return .gray // Пауза
        case .pausedSeeding:
            return .green // Скачивание завершено
        case .queued:
            return .orange // В очереди
        case .checking, .allocating, .moving:
            return .gray // Автоматические процессы
        case .seeding:
            return .green // Активная раздача
        case .error, .missingFiles:
            return .red // Ошибки
        case .unknown:
            return .gray // Неизвестное состояние
        }
    }
    
    private var isButtonDisabled: Bool {
        switch state {
        case .checking, .allocating, .moving, .unknown:
            return true
        default:
            return false
        }
    }
    
    private func pauseTorrent() {
//        let url = "\(apiBaseUrl)/torrents/pause"
//        let parameters: [String: String] = ["hashes": torrentHash]
//        let headers: HTTPHeaders = ["Cookie": "SID=\(sid)"]
//        
//        AF.request(url, method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default, headers: headers)
//            .response { response in
//                if case .failure(let error) = response.result {
//                    print("Failed to pause torrent: \(error)")
//                }
//            }
    }
    
    private func resumeTorrent() {
//        let url = "\(apiBaseUrl)/torrents/resume"
//        let parameters: [String: String] = ["hashes": torrentHash]
//        let headers: HTTPHeaders = ["Cookie": "SID=\(sid)"]
//        
//        AF.request(url, method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default, headers: headers)
//            .response { response in
//                if case .failure(let error) = response.result {
//                    print("Failed to resume torrent: \(error)")
//                }
//            }
    }
    
    private func forceStartTorrent() {
//        let url = "\(apiBaseUrl)/torrents/setForceStart"
//        let parameters: [String: String] = ["hashes": torrentHash, "value": "true"]
//        let headers: HTTPHeaders = ["Cookie": "SID=\(sid)"]
//        
//        AF.request(url, method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default, headers: headers)
//            .response { response in
//                if case .failure(let error) = response.result {
//                    print("Failed to force start torrent: \(error)")
//                }
//            }
    }
    
    private func recheckTorrent() {
//        let url = "\(apiBaseUrl)/torrents/recheck"
//        let parameters: [String: String] = ["hashes": torrentHash]
//        let headers: HTTPHeaders = ["Cookie": "SID=\(sid)"]
//        
//        AF.request(url, method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default, headers: headers)
//            .response { response in
//                if case .failure(let error) = response.result {
//                    print("Failed to recheck torrent: \(error)")
//                }
//            }
    }
}

#Preview {
    VStack {
        DownloadButton(progress: 0.33, state: .downloading, action: { _ in })
        DownloadButton(progress: 0.33, state: .paused, action: { _ in })
        DownloadButton(progress: 1, state: .pausedSeeding, action: { _ in })
        DownloadButton(progress: 0.33, state: .queued, action: { _ in })
        DownloadButton(progress: 0.33, state: .checking, action: { _ in })
        DownloadButton(progress: 0.33, state: .seeding, action: { _ in })
        DownloadButton(progress: 0.33, state: .error, action: { _ in })
        DownloadButton(progress: 0.33, state: .missingFiles, action: { _ in })
        DownloadButton(progress: 0.33, state: .unknown, action: { _ in })
    }
    .padding()
}
