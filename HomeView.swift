//
//  SwiftUIView.swift
//  PitchTrackThorsen
//
//  Created by NIKLAS THORSEN on 11/10/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: DataStore
    let teamIndex: Int
    @State var selectedTab = 0

    var body: some View {
        VStack(spacing: 0) {
            Text(store.teams[teamIndex].name)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.top)

            Spacer()

            TabView(selection: $selectedTab) {
                HomeTab(teamIndex: teamIndex)
                    .tag(0)
                    .tabItem { Label("Home", systemImage: "house.fill") }

                TeamView(teamIndex: teamIndex)
                    .tag(1)
                    .tabItem { Label("Team", systemImage: "person.3.fill") }

                PitcherView(teamIndex: teamIndex)
                    .tag(2)
                    .tabItem { Label("Pitching", systemImage: "figure.baseball") }
            }
        }
        .navigationBarBackButtonHidden(false)
    }
}

import SwiftUI

struct HomeTab: View {
    @EnvironmentObject var store: DataStore
    let teamIndex: Int

    var pitchers: [Pitchers] { store.teams[teamIndex].pitchers }
    var games: [GameRecord] { store.teams[teamIndex].gameRecords }

    var mostUsedPitchers: [PitcherUsage] {
        pitchers.map { pitcher in
            let pitcherGames = games.filter { $0.pitcherName == pitcher.name }
            let lastGame = pitcherGames.map { $0.date }.max()
            return PitcherUsage(pitcher: pitcher, gameCount: pitcherGames.count, lastUsed: lastGame)
        }
        .sorted { $0.gameCount > $1.gameCount }
    }

    var needsBullpen: [PitcherUsage] {
        mostUsedPitchers.filter { usage in
            guard let last = usage.lastUsed else { return true }
            return Calendar.current.dateComponents([.day], from: last, to: Date()).day ?? 0 >= 4
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // Start a game shortcut
                NavigationLink(destination: GameView(teamIndex: teamIndex)) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Start Tracking")
                                .font(.headline).foregroundColor(.white)
                            Text("Begin a new game")
                                .font(.caption).foregroundColor(.white.opacity(0.8))
                        }
                        Spacer()
                        Image(systemName: "baseball.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding()
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal)
                .padding(.top)

                // Needs bullpen work
                VStack(alignment: .leading, spacing: 10) {
                    Text("Needs Bullpen Work")
                        .font(.headline).padding(.horizontal)

                    if pitchers.isEmpty {
                        emptyNote("No pitchers added yet.")
                    } else if needsBullpen.isEmpty {
                        emptyNote("Everyone has thrown recently.")
                    } else {
                        ForEach(needsBullpen, id: \.pitcher.id) { usage in
                            HStack {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(usage.pitcher.name)
                                        .font(.subheadline).fontWeight(.medium)
                                    if let last = usage.lastUsed {
                                        Text("Last threw \(last, style: .relative) ago")
                                            .font(.caption).foregroundColor(.gray)
                                    } else {
                                        Text("Has not thrown yet")
                                            .font(.caption).foregroundColor(.gray)
                                    }
                                }
                                Spacer()
                                Image(systemName: "exclamationmark.circle")
                                    .foregroundColor(.orange)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal)
                        }
                    }
                }

                // Most used pitchers
                VStack(alignment: .leading, spacing: 10) {
                    Text("Most Used Pitchers")
                        .font(.headline).padding(.horizontal)

                    if pitchers.isEmpty {
                        emptyNote("No pitchers added yet.")
                    } else if games.isEmpty {
                        emptyNote("No games tracked yet.")
                    } else {
                        ForEach(mostUsedPitchers.prefix(5), id: \.pitcher.id) { usage in
                            HStack {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(usage.pitcher.name)
                                        .font(.subheadline).fontWeight(.medium)
                                    Text(usage.pitcher.pitches.joined(separator: " · "))
                                        .font(.caption).foregroundColor(.gray)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 3) {
                                    Text("\(usage.gameCount)")
                                        .font(.subheadline).fontWeight(.semibold)
                                    Text(usage.gameCount == 1 ? "game" : "games")
                                        .font(.caption2).foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal)
                        }
                    }
                }

                Spacer(minLength: 20)
            }
        }
    }

    func emptyNote(_ message: String) -> some View {
        Text(message)
            .font(.subheadline).foregroundColor(.gray)
            .padding(.horizontal)
    }
}

struct PitcherUsage {
    let pitcher: Pitchers
    let gameCount: Int
    let lastUsed: Date?
}
