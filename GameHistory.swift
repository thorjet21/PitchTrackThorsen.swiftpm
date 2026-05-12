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

    var pitchers: [Pitchers] { store.teams[teamIndex].pitchers }
    var games: [GameRecord] { store.teams[teamIndex].gameRecords }

    var body: some View {
        if games.isEmpty {
            VStack {
                Spacer()
                Text("No games recorded yet")
                    .font(.headline).foregroundColor(.gray)
                Text("Start tracking a game from the Pitching tab.")
                    .font(.subheadline).foregroundColor(.gray)
                    .multilineTextAlignment(.center).padding(.horizontal)
                Spacer()
            }
        } else {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(pitchers) { pitcher in
                        let pitcherGames = games.filter { $0.pitcherName == pitcher.name }
                        if !pitcherGames.isEmpty {
                            PitcherGameStatCard(pitcher: pitcher, games: pitcherGames)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
        }
    }
}
