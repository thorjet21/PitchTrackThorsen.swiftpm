//
//  SwiftUIView.swift
//  PitchTrackThorsen
//
//  Created by Niklas Thorsen on 5/11/26.
//

import SwiftUI

struct PitcherVsOpponentDetailView: View {
    let pitcher: PitcherVsOpponent
    let opponentName: String

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // Stat grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    statCard("Games",      "\(pitcher.gameCount)")
                    statCard("Pitches",    "\(pitcher.totalPitches)")
                    statCard("Strikes",    "\(pitcher.strikeCount)")
                    statCard("Balls",      "\(pitcher.totalPitches - pitcher.strikeCount)")
                    statCard("Strike %",   String(format: "%.0f%%", pitcher.strikePercent * 100))
                    statCard("Avg / Game", String(format: "%.0f", pitcher.avgPitchesPerGame))
                }
                .padding(.horizontal)

                // Pitch type breakdown
                if !pitcher.pitchTypeBreakdown.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("By Pitch Type").font(.headline).padding(.horizontal)

                        ForEach(pitcher.pitchTypeBreakdown, id: \.type) { entry in
                            VStack(spacing: 6) {
                                HStack {
                                    Text(entry.type).font(.subheadline).fontWeight(.medium)
                                    Spacer()
                                    Text("\(entry.count) pitches").font(.caption).foregroundColor(.gray)
                                    Text("·").foregroundColor(.gray)
                                    Text(String(format: "%.0f%% K", entry.strikePercent * 100))
                                        .font(.caption).fontWeight(.medium).foregroundColor(.green)
                                }

                                GeometryReader { geo in
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color(.systemGray5))
                                            .frame(height: 6)
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color.blue)
                                            .frame(
                                                width: geo.size.width * CGFloat(entry.strikePercent),
                                                height: 6
                                            )
                                    }
                                }
                                .frame(height: 6)
                            }
                            .padding(.horizontal)
                        }
                    }
                }

                // Per-game history
                VStack(alignment: .leading, spacing: 10) {
                    Text("Games vs \(opponentName)").font(.headline).padding(.horizontal)

                    ForEach(pitcher.games.sorted { $0.date > $1.date }) { game in
                        NavigationLink(destination: GameDetailView(game: game)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(game.date, style: .date)
                                        .font(.subheadline).fontWeight(.medium)
                                    Text("\(game.pitchCount) pitches")
                                        .font(.caption).foregroundColor(.gray)
                                }
                                Spacer()
                                Text(String(format: "%.0f%% K", game.strikePercent * 100))
                                    .font(.subheadline).fontWeight(.medium).foregroundColor(.green)
                                Image(systemName: "chevron.right")
                                    .font(.caption2).foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal)
                        }
                        .buttonStyle(.plain)
                    }
                }

                Spacer(minLength: 20)
            }
            .padding(.top)
        }
        .navigationTitle(pitcher.pitcherName)
        .navigationBarTitleDisplayMode(.large)
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
