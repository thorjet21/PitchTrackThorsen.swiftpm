//
//  SwiftUIView.swift
//  PitchTrackThorsen
//
//  Created by Niklas Thorsen on 5/11/26.
//

import SwiftUI

struct OpponentDetailView: View {
    let summary: OpponentSummary

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // Pitcher cards
                VStack(alignment: .leading, spacing: 12) {
                    Text("My Pitchers").font(.headline).padding(.horizontal)

                    ForEach(summary.pitcherSummaries) { pitcher in
                        NavigationLink(destination: PitcherVsOpponentDetailView(pitcher: pitcher, opponentName: summary.name)) {
                            PitcherVsOpponentCard(pitcher: pitcher)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)
                    }
                }

                // Game history
                VStack(alignment: .leading, spacing: 10) {
                    Text("Game History").font(.headline).padding(.horizontal)

                    ForEach(summary.gamesSortedByDate) { game in
                        NavigationLink(destination: GameDetailView(game: game)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(game.pitcherName)
                                        .font(.subheadline).fontWeight(.medium)
                                    Text(game.date, style: .date)
                                        .font(.caption).foregroundColor(.gray)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 3) {
                                    Text("\(game.pitchCount) pitches")
                                        .font(.caption).foregroundColor(.gray)
                                    Text(String(format: "%.0f%% K", game.strikePercent * 100))
                                        .font(.caption).fontWeight(.medium).foregroundColor(.green)
                                }
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
        .navigationTitle(summary.name)
        .navigationBarTitleDisplayMode(.large)
    }
}

struct PitcherVsOpponentCard: View {
    let pitcher: PitcherVsOpponent

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(pitcher.pitcherName).font(.headline)
                Spacer()
                Text("\(pitcher.gameCount) \(pitcher.gameCount == 1 ? "game" : "games")")
                    .font(.caption).foregroundColor(.gray)
            }

            HStack(spacing: 0) {
                miniStat("Pitches",    "\(pitcher.totalPitches)")
                Divider().frame(height: 32)
                miniStat("Strikes",    "\(pitcher.strikeCount)")
                Divider().frame(height: 32)
                miniStat("Strike %",   String(format: "%.0f%%", pitcher.strikePercent * 100))
                Divider().frame(height: 32)
                miniStat("Avg / Game", String(format: "%.0f", pitcher.avgPitchesPerGame))
            }
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 8))
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
