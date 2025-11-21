//
//  SwiftUIView.swift
//  PitchTrackThorsen
//
//  Created by NIKLAS THORSEN on 11/12/25.
//

import SwiftUI

struct BullpenView: View {
    @Binding var pitchers: [Pitchers]
    @State var showingPicker = false
    @State var selectedPitcher: Pitchers? = nil
    @State var selectedPitchType = ""
    @State var strikeOrBall = ""
    @State var selectedLocation = ""
    @State var lastPitchInfo = ""

    // 3x3 strike zone labels
    let zoneButtons = [
        ["High-In", "High-Middle", "High-Away"],
        ["Mid-In", "Mid-Middle", "Mid-Away"],
        ["Low-In", "Low-Middle", "Low-Away"]
    ]

    // Grid for pitch type buttons
    let pitchColumns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(spacing: 20) {
            Text("Bullpen")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.top)

            Spacer(minLength: 10)

            // Pitcher picker
            Button {
                showingPicker = true
            } label: {
                Text(selectedPitcher == nil ? "Select Pitcher" : "Change Pitcher")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
            }
            .confirmationDialog("Choose Pitcher", isPresented: $showingPicker) {
                ForEach(pitchers, id: \.id) { p in
                    Button(p.name) {
                        selectedPitcher = p
                        selectedPitchType = ""
                        strikeOrBall = ""
                        selectedLocation = ""
                        lastPitchInfo = ""
                    }
                }
                Button("Cancel", role: .cancel) {}
            }

            if let pitcher = selectedPitcher {
                ScrollView {
                    VStack(spacing: 16) {

                        // Pitcher name
                        Text("Tracking: \(pitcher.name)")
                            .font(.title2)

                        // STATS SECTION (bullpen-relevant only)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Session Stats")
                                .font(.headline)
                                .padding(.horizontal)

                            HStack(spacing: 12) {
                                statBox(title: "Pitches", value: "\(pitcher.pitchcount)")
                                statBox(
                                    title: "Strike %",
                                    value: pitcher.pitchcount == 0
                                        ? "0%"
                                        : String(format: "%.0f%%", pitcher.strike * 100)
                                )
                                statBox(
                                    title: "Last Pitch",
                                    value: lastPitchInfo.isEmpty ? "-" : lastPitchInfo
                                )
                            }
                            .padding(.horizontal)
                        }

                        // PITCH TYPE BUTTONS – ONLY THIS PITCHER'S PITCHES
                        if pitcher.pitches.isEmpty {
                            Text("No pitches set for this pitcher.\nEdit the pitcher to add pitches.")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                        } else {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Pitch Type")
                                    .font(.headline)
                                    .padding(.horizontal)

                                LazyVGrid(columns: pitchColumns, spacing: 10) {
                                    ForEach(pitcher.pitches, id: \.self) { pitch in
                                        Button {
                                            selectedPitchType = pitch
                                        } label: {
                                            Text(pitch)
                                                .font(.caption)
                                                .padding(8)
                                                .frame(maxWidth: .infinity)
                                                .background(selectedPitchType == pitch ? .blue : .gray.opacity(0.3))
                                                .foregroundColor(.white)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }

                        // Strike / Ball chooser
                        HStack {
                            Button {
                                strikeOrBall = "Strike"
                            } label: {
                                Text("Strike")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(strikeOrBall == "Strike" ? .green : .gray.opacity(0.3))
                                    .foregroundColor(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }

                            Button {
                                strikeOrBall = "Ball"
                            } label: {
                                Text("Ball")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(strikeOrBall == "Ball" ? .red : .gray.opacity(0.3))
                                    .foregroundColor(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        .padding(.horizontal)

                        // Strike zone buttons
                        Text("Choose Pitch Location")
                            .font(.subheadline)

                        VStack(spacing: 10) {
                            ForEach(0..<zoneButtons.count, id: \.self) { row in
                                HStack(spacing: 10) {
                                    ForEach(0..<zoneButtons[row].count, id: \.self) { col in
                                        let zone = zoneButtons[row][col]

                                        Button {
                                            selectedLocation = zone
                                        } label: {
                                            Text(zone)
                                                .font(.caption)
                                                .padding(8)
                                                .frame(maxWidth: .infinity)
                                                .background(selectedLocation == zone ? .blue : .gray.opacity(0.2))
                                                .foregroundColor(.white)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }

                        // Save pitch
                        Button {
                            savePitch()
                        } label: {
                            Text("Save Pitch")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.blue)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(.horizontal)
                        }
                        .disabled(
                            selectedPitchType.isEmpty ||
                            strikeOrBall.isEmpty ||
                            selectedLocation.isEmpty ||
                            selectedPitcher == nil
                        )
                    }
                }
            }

            Spacer()
        }
    }

    // Small reusable view for each stat box
    func statBox(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.headline)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    func savePitch() {
        guard let pitcher = selectedPitcher else { return }

        // update bullpen stats: pitchcount + strike %
        let oldCount = pitcher.pitchcount
        pitcher.pitchcount += 1

        let previousStrikes = Int(round(pitcher.strike * Double(max(oldCount, 1))))
        let newStrikes = strikeOrBall == "Strike" ? previousStrikes + 1 : previousStrikes
        pitcher.strike = Double(newStrikes) / Double(pitcher.pitchcount)

        // push back into array
        if let index = pitchers.firstIndex(where: { $0.id == pitcher.id }) {
            pitchers[index] = pitcher
            selectedPitcher = pitchers[index]
        }

        // update last pitch summary
        lastPitchInfo = "\(selectedPitchType) • \(strikeOrBall) • \(selectedLocation)"

        // Optional: reset selections for next pitch
        selectedPitchType = ""
        strikeOrBall = ""
        selectedLocation = ""
    }
}
