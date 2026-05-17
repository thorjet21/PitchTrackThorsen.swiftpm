//
//  File.swift
//  PitchTrackThorsen
//
//  Created by Niklas Thorsen on 5/15/26.
//

import SwiftUI

struct BullpenPitcherDetailView: View {
    @EnvironmentObject var store: DataStore
    let teamIndex: Int
    let pitcherIndex: Int

    var pitcher: Pitchers { store.teams[teamIndex].pitchers[pitcherIndex] }

    var strikeCount: Int {
        Int(round(pitcher.strike * Double(pitcher.pitchcount)))
    }
    var ballCount: Int { pitcher.pitchcount - strikeCount }
    var strikePct: String {
        pitcher.pitchcount == 0 ? "0%" : String(format: "%.0f%%", pitcher.strike * 100)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // Count bar
                HStack(spacing: 0) {
                    countBadge(label: "Pitches",  value: "\(pitcher.pitchcount)", color: .blue)
                    Divider()
                    countBadge(label: "Strikes",  value: "\(strikeCount)",        color: .green)
                    Divider()
                    countBadge(label: "Balls",    value: "\(ballCount)",          color: .red)
                    Divider()
                    countBadge(label: "Strike %", value: strikePct,               color: .orange)
                }
                .frame(height: 60)
                .background(Color(.systemBackground))
                .overlay(Rectangle().stroke(Color(.systemGray4), lineWidth: 0.5))

                VStack(spacing: 20) {

                    // Strike / Ball split
                    if pitcher.pitchcount > 0 {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Strike / Ball Split").font(.headline).padding(.horizontal)

                            VStack(spacing: 8) {
                                splitBar(
                                    label: "Strikes",
                                    count: strikeCount,
                                    total: pitcher.pitchcount,
                                    color: .green
                                )
                                splitBar(
                                    label: "Balls",
                                    count: ballCount,
                                    total: pitcher.pitchcount,
                                    color: .red
                                )
                            }
                            .padding(.horizontal)
                        }
                    }

                    // Pitch arsenal
                    if !pitcher.pitches.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Pitch Arsenal").font(.headline).padding(.horizontal)

                            LazyVGrid(
                                columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
                                spacing: 8
                            ) {
                                ForEach(pitcher.pitches, id: \.self) { pitch in
                                    Text(pitch)
                                        .font(.caption).fontWeight(.medium)
                                        .frame(maxWidth: .infinity).padding(.vertical, 10)
                                        .background(Color(.systemGray5))
                                        .foregroundColor(.primary)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    if pitcher.pitchcount == 0 {
                        Spacer(minLength: 40)
                        Text("No pitches logged yet.")
                            .font(.subheadline).foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }

                    Spacer(minLength: 20)
                }
                .padding(.top, 16)
            }
        }
        .navigationTitle(pitcher.name)
        .navigationBarTitleDisplayMode(.large)
    }

    func countBadge(label: String, value: String, color: Color) -> some View {
        VStack(spacing: 2) {
            Text(value).font(.title3).fontWeight(.semibold).foregroundColor(color)
            Text(label).font(.caption2).foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }

    func splitBar(label: String, count: Int, total: Int, color: Color) -> some View {
        VStack(spacing: 6) {
            HStack {
                Text(label).font(.caption).fontWeight(.medium)
                Spacer()
                Text("\(count)").font(.caption).foregroundColor(.gray)
                Text("·").foregroundColor(.gray)
                Text(String(format: "%.0f%%", Double(count) / Double(total) * 100))
                    .font(.caption).fontWeight(.medium).foregroundColor(color)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray5))
                        .frame(height: 6)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(
                            width: geo.size.width * CGFloat(Double(count) / Double(total)),
                            height: 6
                        )
                }
            }
            .frame(height: 6)
        }
    }
}
