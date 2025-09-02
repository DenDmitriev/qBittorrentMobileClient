//
//  TorrentNameParser.swift
//  qBittorrentMobileClient
//
//  Created by Denis Dmitriev on 01.09.2025.
//

import Foundation
import SwiftUI

struct TorrentNameParser {
    static func parseTorrentName(_ name: String) -> TorrentTitle {
        // Регулярные выражения для извлечения данных
        let seasonEpisodePattern = try! NSRegularExpression(pattern: "S(\\d{1,2})E(\\d{1,2})")
        let seasonOnlyPattern = try! NSRegularExpression(pattern: "\\b(\\d{1,2})\\s*-\\s*LostFilm")
        let formatPattern = try! NSRegularExpression(pattern: "(1080p|720p|2160p|4K|2K|BluRay|WEB-DL|WEBRip|HDRip|DVDRip|HDTV|SDTV)")
        let yearPattern = try! NSRegularExpression(pattern: "\\b(\\d{4}(?:/\\d{4})*(?:\\s*,\\s*\\d{4})?)\\b")
        
        // Извлечение формата
        let formatRange = formatPattern.firstMatch(in: name, options: [], range: NSRange(location: 0, length: name.utf16.count))
        let format = formatRange.map { String(name[Range($0.range, in: name)!]) }
        
        // Извлечение года
        let yearRange = yearPattern.firstMatch(in: name, options: [], range: NSRange(location: 0, length: name.utf16.count))
        let year = yearRange.map { String(name[Range($0.range, in: name)!]) }
        
        // Извлечение сезона и эпизода
        var season: Int?
        var episode: Int?
        
        if let match = seasonEpisodePattern.firstMatch(in: name, options: [], range: NSRange(location: 0, length: name.utf16.count)) {
            season = Int(name[Range(match.range(at: 1), in: name)!])
            episode = Int(name[Range(match.range(at: 2), in: name)!])
        } else if let match = seasonOnlyPattern.firstMatch(in: name, options: [], range: NSRange(location: 0, length: name.utf16.count)) {
            season = Int(name[Range(match.range(at: 1), in: name)!])
        }
        
        // Извлечение названия
        var torrentName = name
        if let season, let episode {
            torrentName = torrentName.components(separatedBy: ".S\(String(format: "%02d", season))E\(String(format: "%02d", episode))").first ?? name
        } else if let season {
            torrentName = torrentName.components(separatedBy: " \(season) -").first ?? name
        }
        if let year {
            torrentName = torrentName.components(separatedBy: year).first ?? torrentName
        }
        if let format {
            torrentName = torrentName.components(separatedBy: format).first ?? torrentName
        }
        
        torrentName = torrentName.components(separatedBy: ".").joined(separator: " ").trimmingCharacters(in: .whitespaces)
        
        // Определение типа
        if season != nil {
            return .series(TorrentTitle.Series(name: torrentName, session: season, episode: episode, format: format, year: year, original: name))
        } else if format != nil || year != nil {
            return .movie(TorrentTitle.Movie(name: torrentName, format: format, year: year, original: name))
        } else {
            return .other(TorrentTitle.Other(original: name))
        }
    }
}

struct TorrentTitlesView: View {
    let torrentNames = [
        "The.Tree.of.Life.2011.1080p.BluRay.2xRus.Eng.HDCLUB.mkv",
        "Nine Perfect Strangers 1 - LostFilm.TV [1080p]",
        "The Little Drummer Girl 1 - LostFilm.TV [1080p]",
        "F1.The.Movie.1080p.rus.LostFilm.TV.mkv",
        "How.To.Train.Your.Dragon.1080p.rus.LostFilm.TV.mkv",
        "Alien.Earth.S01E01.1080p.rus.LostFilm.TV.mkv",
        "Wednesday.S02E02.1080p.rus.LostFilm.TV.mkv",
        "Revival.S01E01.1080p.rus.LostFilm.TV.mkv",
        "Dept.Q.S01E07.1080p.rus.LostFilm.TV.mkv",
        "Крестный отец: Трилогия / The Godfather Collection: The Coppola Restoration (Френсис Форд Коппола / Francis Ford Coppola) [1972/1974/1990, США, драма,"
    ]
    
    var body: some View {
        NavigationView {
            List(torrentNames.map(TorrentNameParser.parseTorrentName), id: \.self) { torrent in
                VStack(alignment: .leading, spacing: 4) {
                    Text(torrent.original)
                        .font(.caption2)
                        .foregroundColor(.gray)
                    
                    switch torrent {
                    case .movie(let movie):
                        Text(movie.name)
                            .font(.headline)
                            .lineLimit(2)
                        HStack {
                            if let year = movie.year {
                                Text(year)
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                            if let format = movie.format {
                                Text(format)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    case .series(let series):
                        Text(series.name)
                            .font(.headline)
                            .lineLimit(2)
                        HStack {
                            if let year = series.year {
                                Text(year)
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                            if let season = series.session {
                                Text("Season \(season)")
                                    .font(.subheadline)
                            }
                            if let episode = series.episode {
                                Text("Episode \(episode)")
                                    .font(.subheadline)
                            }
                        }
                        if let format = series.format {
                            Text(format)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    case .other(let other):
                        Text(other.original)
                            .font(.headline)
                            .lineLimit(2)
                    }
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Torrents")
        }
    }
}

extension TorrentTitle {
    var original: String {
        switch self {
        case .movie(let movie):
            return movie.original
        case .series(let series):
            return series.original
        case .other(let other):
            return other.original
        }
    }
}

#Preview {
    TorrentTitlesView()
}
