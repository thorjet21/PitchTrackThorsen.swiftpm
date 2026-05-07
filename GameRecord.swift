//
//  File.swift
//  PitchTrackThorsen
//
//  Created by NIKLAS THORSEN on 5/7/26.
//

import Foundation

struct GameRecord: Identifiable, Codable {
    let id: UUID
    var opponentName: String
    var date: Date
    var pitcherName: String
    var pitches: [GamePitch]

    init(id: UUID = UUID(), opponentName: String, date: Date = Date(),
         pitcherName: String, pitches: [GamePitch] = []) {
        self.id = id
        self.opponentName = opponentName
        self.date = date
        self.pitcherName = pitcherName
        self.pitches = pitches
    }

    var pitchCount: Int { pitches.count }
    var strikeCount: Int { pitches.filter { $0.result == "Strike" }.count }
    var strikePercent: Double {
        pitchCount == 0 ? 0 : Double(strikeCount) / Double(pitchCount)
    }
}

struct GamePitch: Identifiable, Codable {
    let id: UUID
    var type: String
    var result: String
    var location: String
    var inning: Int
    var batter: Int

    init(id: UUID = UUID(), type: String, result: String,
         location: String, inning: Int, batter: Int) {
        self.id = id
        self.type = type
        self.result = result
        self.location = location
        self.inning = inning
        self.batter = batter
    }
}

