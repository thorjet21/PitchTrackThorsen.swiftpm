//
//  File.swift
//  PitchTrackThorsen
//
//  Created by NIKLAS THORSEN on 11/6/25.
//

import Foundation

struct Pitchers: Identifiable, Codable {
    let id: UUID
    var name: String
    var pitchcount: Int
    var inning: Double
    var era: Double
    var strike: Double
    var pitches: [String]

    init(
        id: UUID = UUID(),
        name: String,
        pitchcount: Int = 0,
        inning: Double = 0.0,
        era: Double = 0.0,
        strike: Double = 0.0,
        pitches: [String] = []
    ) {
        self.id = id
        self.name = name
        self.pitchcount = pitchcount
        self.inning = inning
        self.era = era
        self.strike = strike
        self.pitches = pitches
    }
}
