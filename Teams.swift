//
//  File.swift
//  PitchTrackThorsen
//
//  Created by NIKLAS THORSEN on 11/6/25.
//
import Foundation

struct Teams: Identifiable, Codable {
    let id: UUID
    var name: String
    var pitchers: [Pitchers]
    var gameRecords: [GameRecord]

    init(id: UUID = UUID(), name: String, pitchers: [Pitchers] = [], gameRecords: [GameRecord] = []) {
        self.id = id
        self.name = name
        self.pitchers = pitchers
        self.gameRecords = gameRecords
    }
}
