//
//  SwiftUIView.swift
//  PitchTrackThorsen
//
//  Created by Niklas Thorsen on 5/11/26.
//

import SwiftUI

struct PitcherGameStatCard: View {
    let pitcher: Pitchers
    let games: [GameRecord]

    var allPitches: [GamePitch] { games.flatMap { $0.pitches } }
    var totalPitches: Int { allPitches.count }
    var totalStrikes: Int { allPitches.filter { $0.result == "Strike" }.count }
    var totalBalls: Int { totalPitches - totalStrikes }
    var strikePercent: Double {
        totalPitches == 0 ? 0 : Double(totalStrikes) / Double(totalPitches)
    }
    var avgPitchesPerGame: Double {
        games.isEmpty ? 0 : Double(totalPitches) / Double(games.count)
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

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            // Header
            HStack {
                Text(pitcher.name).font(.headline)
                Spacer()
                Text("\(games.count) \(games.count == 1 ? "game" : "games")")
                    .font(.caption).foregroundColor(.gray)
            }

            // Stat row
            HStack(spacing: 0) {
                miniStat("Pitches",    "\(totalPitches)")
                Divider().frame(height: 32)
                miniStat("Strikes",    "\(totalStrikes)")
                Divider().frame(height: 32)
                miniStat("Balls",      "\(totalBalls)")
                Divider().frame(height: 32)
                miniStat("Strike %",   String(format: "%.0f%%", strikePercent * 100))
                Divider().frame(height: 32)
                miniStat("Avg/Game",   String(format: "%.0f", avgPitchesPerGame))
            }
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 8))

            // Pitch type breakdown
            if !pitchTypeBreakdown.isEmpty {
                VStack(spacing: 8) {
                    ForEach(pitchTypeBreakdown, id: \.type) { entry in
                        VStack(spacing: 4) {
                            HStack {
                                Text(entry.type)
                                    .font(.caption).fontWeight(.medium)
                                Spacer()
                                Text("\(entry.count)")
                                    .font(.caption).foregroundColor(.gray)
                                Text("·").foregroundColor(.gray)
                                Text(String(format: "%.0f%% K", entry.strikePercent * 100))
                                    .font(.caption).foregroundColor(.green)
                            }
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color(.systemGray5))
                                        .frame(height: 5)
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.blue)
                                        .frame(
                                            width: geo.size.width * CGFloat(entry.strikePercent),
                                            height: 5
                                        )
                                }
                            }
                            .frame(height: 5)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray4), lineWidth: 0.5)
        )
    }

    func miniStat(_ label: String, _ value: String) -> some View {
        VStack(spacing: 3) {
            Text(value).font(.subheadline).fontWeight(.semibold)
            Text(label).font(.caption2).foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 8)
    }
}
