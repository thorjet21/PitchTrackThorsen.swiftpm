//
//  SwiftUIView.swift
//  PitchTrackThorsen
//
//  Created by NIKLAS THORSEN on 5/7/26.
//

import SwiftUI

struct GameDetailView: View {
    let game: GameRecord

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 4) {
                    Text("vs \(game.opponentName)").font(.title2).fontWeight(.semibold)
                    Text(game.pitcherName).font(.subheadline).foregroundColor(.gray)
                    Text(game.date, style: .date).font(.caption).foregroundColor(.gray)
                }
                .padding(.top)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    statCard("Pitches",  "\(game.pitchCount)")
                    statCard("Strikes",  "\(game.strikeCount)")
                    statCard("Balls",    "\(game.pitchCount - game.strikeCount)")
                    statCard("Strike %", String(format: "%.0f%%", game.strikePercent * 100))
                    statCard("Innings",  game.pitches.isEmpty ? "—" : "\(game.pitches.map { $0.inning }.max() ?? 1)")
                    statCard("Batters",  game.pitches.isEmpty ? "—" : "\(Set(game.pitches.map { "\($0.inning)-\($0.batter)" }).count)")
                }
                .padding(.horizontal)

                let types = Dictionary(grouping: game.pitches, by: { $0.type })
                if !types.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("By Pitch Type").font(.headline).padding(.horizontal)
                        ForEach(types.keys.sorted(), id: \.self) { type in
                            let ps = types[type]!
                            let strikes = ps.filter { $0.result == "Strike" }.count
                            HStack {
                                Text(type).font(.subheadline).fontWeight(.medium)
                                Spacer()
                                Text("\(ps.count)").font(.subheadline).foregroundColor(.gray)
                                Text("·").foregroundColor(.gray)
                                Text(String(format: "%.0f%% K", Double(strikes) / Double(ps.count) * 100))
                                    .font(.subheadline).foregroundColor(.green)
                            }
                            .padding(.horizontal)
                            Divider().padding(.horizontal)
                        }
                    }
                }

                let locations = Dictionary(grouping: game.pitches, by: { $0.location })
                if !locations.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("By Location").font(.headline).padding(.horizontal)
                        ForEach(locations.keys.sorted(), id: \.self) { loc in
                            HStack {
                                Text(loc).font(.subheadline).fontWeight(.medium)
                                Spacer()
                                Text("\(locations[loc]!.count) pitches")
                                    .font(.caption).foregroundColor(.gray)
                            }
                            .padding(.horizontal)
                        }
                    }
                }

                Spacer(minLength: 20)
            }
        }
        .navigationTitle("Game Detail")
        .navigationBarTitleDisplayMode(.inline)
    }

    func statCard(_ label: String, _ value: String) -> some View {
        VStack(spacing: 4) {
            Text(value).font(.title3).fontWeight(.semibold)
            Text(label).font(.caption2).foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 12)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
