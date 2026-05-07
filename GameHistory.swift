//
//  File.swift
//  PitchTrackThorsen
//
//  Created by NIKLAS THORSEN on 5/7/26.
//

import SwiftUI

struct GamesHistoryTab: View {
    @EnvironmentObject var store: DataStore
    let teamIndex: Int

    var games: [GameRecord] { store.teams[teamIndex].gameRecords }

    var body: some View {
        if games.isEmpty {
            VStack {
                Spacer()
                Text("No games recorded yet").font(.headline).foregroundColor(.gray)
                Text("Start tracking a game from the Pitching tab.")
                    .font(.subheadline).foregroundColor(.gray)
                    .multilineTextAlignment(.center).padding(.horizontal)
                Spacer()
            }
        } else {
            List {
                ForEach(games.reversed()) { game in
                    NavigationLink(destination: GameDetailView(game: game)) {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text("vs \(game.opponentName)").font(.headline)
                                Spacer()
                                Text(game.date, style: .date)
                                    .font(.caption).foregroundColor(.gray)
                            }
                            Text(game.pitcherName).font(.subheadline).foregroundColor(.gray)
                            HStack(spacing: 16) {
                                Label("\(game.pitchCount) pitches", systemImage: "baseball")
                                    .font(.caption2).foregroundColor(.secondary)
                                Label(
                                    String(format: "%.0f%% strikes", game.strikePercent * 100),
                                    systemImage: "checkmark.circle"
                                )
                                .font(.caption2).foregroundColor(.green)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
    }
}
