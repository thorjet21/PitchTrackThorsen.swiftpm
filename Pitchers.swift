//
//  File.swift
//  PitchTrackThorsen
//
//  Created by NIKLAS THORSEN on 11/6/25.
//

import Foundation

class Pitchers{
    var name: String
    var pitchcount: Int
    var inning: Double
    var era: Double
    var strike: Double
    var pitches: [String]
    var isOn: [Bool]
    
    
    init(name: String, pitchcount: Int, inning: Double, era: Double, strike: Double, pitches: [String], isOn: [Bool]) {
        self.name = name
        self.pitchcount = pitchcount
        self.inning = inning
        self.era = era
        self.strike = strike
        self.pitches = pitches
        self.isOn = isOn
    }
    
}
