//
//  File.swift
//  PitchTrackThorsen
//
//  Created by Niklas Thorsen on 5/11/26.
//

import Foundation

struct OpponentSummary: Identifiable {
    let id = UUID()
    let name: String
    let games: [GameRecord]

    var gameCount: Int { games.count }

    var lastPlayed: Date? {
        games.map { $0.date }.max()
    }

    var gamesSortedByDate: [GameRecord] {
        games.sorted { $0.date > $1.date }
    }

    var pitcherSummaries: [PitcherVsOpponent] {
        let grouped = Dictionary(grouping: games, by: { $0.pitcherName })
        return grouped.map { name, records in
            PitcherVsOpponent(pitcherName: name, games: records)
        }.sorted { $0.pitcherName < $1.pitcherName }
    }
}

struct PitcherVsOpponent: Identifiable {
    let id = UUID()
    let pitcherName: String
    let games: [GameRecord]

    var gameCount: Int { games.count }

    var allPitches: [GamePitch] { games.flatMap { $0.pitches } }

    var totalPitches: Int { allPitches.count }

    var strikeCount: Int { allPitches.filter { $0.result == "Strike" }.count }

    var strikePercent: Double {
        totalPitches == 0 ? 0 : Double(strikeCount) / Double(totalPitches)
    }

    var avgPitchesPerGame: Double {
        gameCount == 0 ? 0 : Double(totalPitches) / Double(gameCount)
    }

    var pitchTypeBreakdown: [(type: String, count: Int, strikePercent: Double)] {
        let grouped = Dictionary(grouping: allPitches, by: { $0.type })
        return grouped.map { type, pitches in
            let strikes = pitches.filter { $0.result == "Strike" }.count
            return (
                type: type,
                count: pitches.count,
                strikePercent: pitches.isEmpty ? 0 : Double(strikes) / Double(pitches.count)
            )
        }.sorted { $0.count > $1.count }
    }
}
