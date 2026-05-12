//
//  SwiftUIView.swift
//  PitchTrackThorsen
//
//  Created by NIKLAS THORSEN on 11/10/25.
//

import SwiftUI

struct TeamView: View {
    @EnvironmentObject var store: DataStore
    let teamIndex: Int

    var games: [GameRecord] { store.teams[teamIndex].gameRecords }

    var opponents: [OpponentSummary] {
        let grouped = Dictionary(grouping: games, by: { $0.opponentName })
        return grouped.map { name, records in
            OpponentSummary(name: name, games: records)
        }.sorted { $0.name < $1.name }
    }

    var body: some View {
        NavigationStack {
            Group {
                if opponents.isEmpty {
                    VStack {
                        Spacer()
                        Image(systemName: "person.3")
                            .font(.system(size: 48))
                            .foregroundColor(.gray.opacity(0.4))
                            .padding(.bottom, 8)
                        Text("No opponents yet")
                            .font(.headline).foregroundColor(.gray)
                        Text("Teams you face will appear here after you track a game.")
                            .font(.subheadline).foregroundColor(.gray)
                            .multilineTextAlignment(.center).padding(.horizontal, 40)
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(opponents) { opponent in
                            NavigationLink(destination: OpponentDetailView(summary: opponent)) {
                                OpponentRowView(summary: opponent)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Opponents")
        }
    }
}
