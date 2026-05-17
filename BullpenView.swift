//
//  SwiftUIView.swift
//  PitchTrackThorsen
//
//  Created by NIKLAS THORSEN on 11/12/25.
//

import SwiftUI

struct BullpenView: View {
    @EnvironmentObject var store: DataStore
    let teamIndex: Int

    @State var showingPicker = false
    @State var selectedPitcherIndex: Int? = nil
    @State var selectedPitchType = ""
    @State var strikeOrBall = ""
    @State var selectedLocation = ""
    @State var lastPitchInfo = ""

    let zoneLabels = [
        ["High-In", "High-Mid", "High-Away"],
        ["Mid-In",  "Mid-Mid",  "Mid-Away"],
        ["Low-In",  "Low-Mid",  "Low-Away"]
    ]

    var pitchers: [Pitchers] { store.teams[teamIndex].pitchers }

    var pitchCount: Int {
        guard let idx = selectedPitcherIndex else { return 0 }
        return store.teams[teamIndex].pitchers[idx].pitchcount
    }

    var strikePercent: String {
        guard let idx = selectedPitcherIndex else { return "0%" }
        let pitcher = store.teams[teamIndex].pitchers[idx]
        return pitcher.pitchcount == 0 ? "0%" : String(format: "%.0f%%", pitcher.strike * 100)
    }

    var strikeCount: Int {
        guard let idx = selectedPitcherIndex else { return 0 }
        let pitcher = store.teams[teamIndex].pitchers[idx]
        return Int(round(pitcher.strike * Double(pitcher.pitchcount)))
    }

    var ballCount: Int { pitchCount - strikeCount }

    var canSave: Bool {
        !selectedPitchType.isEmpty && !strikeOrBall.isEmpty && !selectedLocation.isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {

            // Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Bullpen").font(.largeTitle).fontWeight(.semibold)
                    if let idx = selectedPitcherIndex {
                        Text("Tracking: \(pitchers[idx].name)")
                            .font(.subheadline).foregroundColor(.gray)
                    }
                }
                Spacer()
                Button { showingPicker = true } label: {
                    Text(selectedPitcherIndex == nil ? "Select" : "Change")
                        .font(.subheadline).fontWeight(.medium)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 14).padding(.vertical, 7)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Capsule())
                }
            }
            .padding()
            .background(Color(.systemGray6))

            if let idx = selectedPitcherIndex {

                // Count bar
                HStack(spacing: 0) {
                    countBadge(label: "Pitches", value: "\(pitchCount)",   color: .blue)
                    Divider()
                    countBadge(label: "Strikes", value: "\(strikeCount)",  color: .green)
                    Divider()
                    countBadge(label: "Balls",   value: "\(ballCount)",    color: .red)
                    Divider()
                    countBadge(label: "Strike %", value: strikePercent,    color: .orange)
                }
                .frame(height: 60)
                .background(Color(.systemBackground))
                .overlay(Rectangle().stroke(Color(.systemGray4), lineWidth: 0.5))

                ScrollView {
                    VStack(spacing: 20) {

                        // Pitch type
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Pitch Type").font(.headline).padding(.horizontal)

                            if pitchers[idx].pitches.isEmpty {
                                Text("No pitches configured. Edit this pitcher to add pitches.")
                                    .font(.caption).foregroundColor(.gray).padding(.horizontal)
                            } else {
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                                    ForEach(pitchers[idx].pitches, id: \.self) { pitch in
                                        Button { selectedPitchType = pitch } label: {
                                            Text(pitch)
                                                .font(.caption).fontWeight(.medium)
                                                .frame(maxWidth: .infinity).padding(.vertical, 10)
                                                .background(selectedPitchType == pitch ? Color.blue : Color(.systemGray5))
                                                .foregroundColor(selectedPitchType == pitch ? .white : .primary)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }

                        // Strike / Ball
                        HStack(spacing: 12) {
                            resultButton("Strike", color: .green, selected: strikeOrBall == "Strike") { strikeOrBall = "Strike" }
                            resultButton("Ball",   color: .red,   selected: strikeOrBall == "Ball")   { strikeOrBall = "Ball" }
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

                        // Save
                        Button { savePitch() } label: {
                            Text("Log Pitch")
                                .font(.headline).frame(maxWidth: .infinity).padding()
                                .background(canSave ? Color.blue : Color.gray.opacity(0.35))
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .disabled(!canSave)
                        .padding(.horizontal)

                        // Last pitch
                        if !lastPitchInfo.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Last Pitch").font(.headline).padding(.horizontal)
                                HStack {
                                    Circle()
                                        .fill(lastPitchInfo.contains("Strike") ? Color.green : Color.red)
                                        .frame(width: 8, height: 8)
                                    Text(lastPitchInfo)
                                        .font(.subheadline)
                                        .foregroundColor(.primary)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(.horizontal)
                            }
                        }

                        Spacer(minLength: 20)
                    }
                    .padding(.top, 16)
                }

            } else {
                Spacer()
                Text("Select a pitcher to begin")
                    .font(.headline).foregroundColor(.gray)
                Spacer()
            }
        }
        .confirmationDialog("Choose Pitcher", isPresented: $showingPicker) {
            ForEach(pitchers.indices, id: \.self) { i in
                Button(pitchers[i].name) {
                    selectedPitcherIndex = i
                    selectedPitchType = ""
                    strikeOrBall = ""
                    selectedLocation = ""
                    lastPitchInfo = ""
                }
            }
            Button("Cancel", role: .cancel) {}
        }
    }

    func countBadge(label: String, value: String, color: Color) -> some View {
        VStack(spacing: 2) {
            Text(value).font(.title3).fontWeight(.semibold).foregroundColor(color)
            Text(label).font(.caption2).foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
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

    func savePitch() {
        guard let idx = selectedPitcherIndex else { return }
        let oldCount = store.teams[teamIndex].pitchers[idx].pitchcount
        store.teams[teamIndex].pitchers[idx].pitchcount += 1
        let prevStrikes = Int(round(store.teams[teamIndex].pitchers[idx].strike * Double(max(oldCount, 1))))
        let newStrikes = strikeOrBall == "Strike" ? prevStrikes + 1 : prevStrikes
        store.teams[teamIndex].pitchers[idx].strike =
            Double(newStrikes) / Double(store.teams[teamIndex].pitchers[idx].pitchcount)

        lastPitchInfo = "\(selectedPitchType) · \(strikeOrBall) · \(selectedLocation)"
        selectedPitchType = ""
        strikeOrBall = ""
        selectedLocation = ""
    }
}
