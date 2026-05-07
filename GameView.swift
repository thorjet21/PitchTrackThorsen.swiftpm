//
//  SwiftUIView.swift
//  PitchTrackThorsen
//
//  Created by NIKLAS THORSEN on 11/12/25.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var store: DataStore
    let teamIndex: Int

    @State private var phase: GamePhase = .setup
    @State private var opponentName = ""
    @State private var selectedPitcherIndex: Int? = nil
    @State private var isNewOpponent = true
    @State private var currentGame = GameRecord(opponentName: "", pitcherName: "")

    enum GamePhase { case setup, tracking, summary }

    var pitchers: [Pitchers] { store.teams[teamIndex].pitchers }
    var pastOpponents: [String] {
        Array(Set(store.teams[teamIndex].gameRecords.map { $0.opponentName })).sorted()
    }

    var body: some View {
        switch phase {
        case .setup:
            GameSetupView(
                teamIndex: teamIndex,
                opponentName: $opponentName,
                selectedPitcherIndex: $selectedPitcherIndex,
                isNewOpponent: $isNewOpponent,
                pastOpponents: pastOpponents,
                pitchers: pitchers
            ) {
                guard let idx = selectedPitcherIndex else { return }
                currentGame = GameRecord(
                    opponentName: opponentName,
                    pitcherName: pitchers[idx].name
                )
                phase = .tracking
            }
        case .tracking:
            GameTrackingView(
                teamIndex: teamIndex,
                game: $currentGame,
                pitcherIndex: selectedPitcherIndex!
            ) {
                store.teams[teamIndex].gameRecords.append(currentGame)
                phase = .summary
            }
        case .summary:
            GameSumView(game: currentGame) {
                phase = .setup
                opponentName = ""
                selectedPitcherIndex = nil
            }
        }
    }
}
