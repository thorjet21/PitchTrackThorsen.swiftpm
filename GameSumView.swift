//
//  SwiftUIView.swift
//  PitchTrackThorsen
//
//  Created by NIKLAS THORSEN on 5/7/26.
//

import SwiftUI

struct GameSumView: View {
    let game: GameRecord
    let onDone: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 52)).foregroundColor(.green).padding(.top)
                    Text("Game Saved").font(.largeTitle).fontWeight(.semibold)
                    Text("vs \(game.opponentName)").font(.title3).foregroundColor(.gray)
                    Text(game.pitcherName).font(.subheadline).foregroundColor(.gray)
                }

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    statCard("Pitches", "\(game.pitchCount)")
                    statCard("Strikes", "\(game.strikeCount)")
                    statCard("Balls",   "\(game.pitchCount - game.strikeCount)")
                    statCard("Strike %", String(format: "%.0f%%", game.strikePercent * 100))
                }
                .padding(.horizontal)

                if !game.pitches.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Pitch Breakdown").font(.headline).padding(.horizontal)
                        let types = Dictionary(grouping: game.pitches, by: { $0.type })
                        ForEach(types.keys.sorted(), id: \.self) { type in
                            let ps = types[type]!
                            let strikes = ps.filter { $0.result == "Strike" }.count
                            HStack {
                                Text(type).font(.subheadline).fontWeight(.medium)
                                Spacer()
                                Text("\(ps.count) pitches").font(.caption).foregroundColor(.gray)
                                Text("·").foregroundColor(.gray)
                                Text(String(format: "%.0f%% K", Double(strikes) / Double(ps.count) * 100))
                                    .font(.caption).foregroundColor(.green)
                            }
                            .padding(.horizontal)
                            Divider().padding(.horizontal)
                        }
                    }
                }

                Button(action: onDone) {
                    Text("Done")
                        .font(.headline).frame(maxWidth: .infinity).padding()
                        .background(Color.blue).foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
    }

    func statCard(_ label: String, _ value: String) -> some View {
        VStack(spacing: 6) {
            Text(value).font(.largeTitle).fontWeight(.semibold)
            Text(label).font(.caption).foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity).padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
