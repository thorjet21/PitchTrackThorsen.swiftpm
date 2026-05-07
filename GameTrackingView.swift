//
//  SwiftUIView.swift
//  PitchTrackThorsen
//
//  Created by NIKLAS THORSEN on 5/7/26.
//

import SwiftUI

struct GameTrackingView: View {
    @EnvironmentObject var store: DataStore
    let teamIndex: Int
    @Binding var game: GameRecord
    let pitcherIndex: Int
    let onFinish: () -> Void

    @State private var selectedPitchType = ""
    @State private var selectedResult = ""
    @State private var selectedLocation = ""
    @State private var currentInning = 1
    @State private var currentBatter = 1
    @State private var showingFinishAlert = false

    let zoneLabels = [
        ["High-In", "High-Mid", "High-Away"],
        ["Mid-In",  "Mid-Mid",  "Mid-Away"],
        ["Low-In",  "Low-Mid",  "Low-Away"]
    ]

    var pitcher: Pitchers { store.teams[teamIndex].pitchers[pitcherIndex] }
    var pitchCount: Int { game.pitches.count }
    var strikeCount: Int { game.pitches.filter { $0.result == "Strike" }.count }
    var ballCount: Int   { game.pitches.filter { $0.result == "Ball" }.count }
    var strikePct: String {
        pitchCount == 0 ? "0%" : String(format: "%.0f%%", Double(strikeCount) / Double(pitchCount) * 100)
    }
    var canSave: Bool {
        !selectedPitchType.isEmpty && !selectedResult.isEmpty && !selectedLocation.isEmpty
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("vs \(game.opponentName)").font(.headline)
                        Text(pitcher.name).font(.subheadline).foregroundColor(.gray)
                    }
                    Spacer()
                    Button { showingFinishAlert = true } label: {
                        Text("End Game")
                            .font(.subheadline).fontWeight(.medium)
                            .foregroundColor(.red)
                            .padding(.horizontal, 14).padding(.vertical, 7)
                            .background(Color.red.opacity(0.1))
                            .clipShape(Capsule())
                    }
                }
                .padding()
                .background(Color(.systemGray6))

                // Count bar
                HStack(spacing: 0) {
                    countBadge(label: "Pitches",  value: "\(pitchCount)",  color: .blue)
                    Divider()
                    countBadge(label: "Strikes",  value: "\(strikeCount)", color: .green)
                    Divider()
                    countBadge(label: "Balls",    value: "\(ballCount)",   color: .red)
                    Divider()
                    countBadge(label: "K%",       value: strikePct,        color: .orange)
                }
                .frame(height: 60)
                .background(Color(.systemBackground))
                .overlay(Rectangle().stroke(Color(.systemGray4), lineWidth: 0.5))

                VStack(spacing: 20) {

                    // Inning / Batter steppers
                    HStack(spacing: 16) {
                        stepperBox(label: "Inning",   value: $currentInning, min: 1, max: 15)
                        stepperBox(label: "Batter #", value: $currentBatter, min: 1, max: 9)
                    }
                    .padding(.horizontal)

                    // Pitch type grid
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Pitch Type").font(.headline).padding(.horizontal)
                        if pitcher.pitches.isEmpty {
                            Text("No pitches configured for this pitcher.")
                                .font(.caption).foregroundColor(.gray).padding(.horizontal)
                        } else {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                                ForEach(pitcher.pitches, id: \.self) { p in
                                    Button { selectedPitchType = p } label: {
                                        Text(p).font(.caption).fontWeight(.medium)
                                            .frame(maxWidth: .infinity).padding(.vertical, 10)
                                            .background(selectedPitchType == p ? Color.blue : Color(.systemGray5))
                                            .foregroundColor(selectedPitchType == p ? .white : .primary)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    // Strike / Ball
                    HStack(spacing: 12) {
                        resultButton("Strike", color: .green, selected: selectedResult == "Strike") { selectedResult = "Strike" }
                        resultButton("Ball",   color: .red,   selected: selectedResult == "Ball")   { selectedResult = "Ball" }
                    }
                    .padding(.horizontal)

                    // Zone grid
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Location").font(.headline).padding(.horizontal)
                        VStack(spacing: 6) {
                            ForEach(0..<3, id: \.self) { row in
                                HStack(spacing: 6) {
                                    ForEach(0..<3, id: \.self) { col in
                                        let zone = zoneLabels[row][col]
                                        Button { selectedLocation = zone } label: {
                                            Text(zone)
                                                .font(.caption2).fontWeight(.medium)
                                                .frame(maxWidth: .infinity).frame(height: 44)
                                                .background(selectedLocation == zone ? Color.blue : Color(.systemGray5))
                                                .foregroundColor(selectedLocation == zone ? .white : .primary)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Log pitch button
                    Button {
                        let pitch = GamePitch(
                            type: selectedPitchType,
                            result: selectedResult,
                            location: selectedLocation,
                            inning: currentInning,
                            batter: currentBatter
                        )
                        game.pitches.append(pitch)
                        selectedPitchType = ""
                        selectedResult = ""
                        selectedLocation = ""
                    } label: {
                        Text("Log Pitch")
                            .font(.headline).frame(maxWidth: .infinity).padding()
                            .background(canSave ? Color.blue : Color.gray.opacity(0.35))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(!canSave)
                    .padding(.horizontal)

                    // Recent pitches
                    if !game.pitches.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Recent Pitches").font(.headline).padding(.horizontal)
                            ForEach(game.pitches.suffix(5).reversed()) { pitch in
                                HStack {
                                    Circle()
                                        .fill(pitch.result == "Strike" ? Color.green : Color.red)
                                        .frame(width: 8, height: 8)
                                    Text(pitch.type).font(.subheadline).fontWeight(.medium)
                                    Text("·").foregroundColor(.gray)
                                    Text(pitch.result).font(.subheadline)
                                        .foregroundColor(pitch.result == "Strike" ? .green : .red)
                                    Spacer()
                                    Text(pitch.location).font(.caption).foregroundColor(.gray)
                                    Text("Inn. \(pitch.inning)").font(.caption).foregroundColor(.gray)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 6)
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .padding(.horizontal)
                            }
                        }
                    }

                    Spacer(minLength: 20)
                }
                .padding(.top, 16)
            }
        }
        .alert("End Game?", isPresented: $showingFinishAlert) {
            Button("End Game", role: .destructive) { onFinish() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will save the game and return to setup.")
        }
    }

    // MARK: - Helpers

    func countBadge(label: String, value: String, color: Color) -> some View {
        VStack(spacing: 2) {
            Text(value).font(.title3).fontWeight(.semibold).foregroundColor(color)
            Text(label).font(.caption2).foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }

    func stepperBox(label: String, value: Binding<Int>, min: Int, max: Int) -> some View {
        VStack(spacing: 6) {
            Text(label).font(.caption).foregroundColor(.gray)
            HStack {
                Button { if value.wrappedValue > min { value.wrappedValue -= 1 } } label: {
                    Image(systemName: "minus.circle.fill").foregroundColor(.blue)
                }
                Text("\(value.wrappedValue)").font(.headline).frame(minWidth: 28, alignment: .center)
                Button { if value.wrappedValue < max { value.wrappedValue += 1 } } label: {
                    Image(systemName: "plus.circle.fill").foregroundColor(.blue)
                }
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    func resultButton(_ label: String, color: Color, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.headline).frame(maxWidth: .infinity).padding()
                .background(selected ? color : Color(.systemGray5))
                .foregroundColor(selected ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
