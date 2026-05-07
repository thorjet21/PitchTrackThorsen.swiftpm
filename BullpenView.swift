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

    let zoneButtons = [
        ["High-In", "High-Middle", "High-Away"],
        ["Mid-In", "Mid-Middle", "Mid-Away"],
        ["Low-In", "Low-Middle", "Low-Away"]
    ]
    let pitchColumns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var pitchers: [Pitchers] { store.teams[teamIndex].pitchers }

    var body: some View {
        VStack(spacing: 20) {
            Text("Bullpen").font(.largeTitle).fontWeight(.semibold).padding(.top)
            Spacer(minLength: 10)

            Button { showingPicker = true } label: {
                Text(selectedPitcherIndex == nil ? "Select Pitcher" : "Change Pitcher")
                    .font(.headline).frame(maxWidth: .infinity).padding()
                    .background(.blue).foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12)).padding(.horizontal)
            }
            .confirmationDialog("Choose Pitcher", isPresented: $showingPicker) {
                ForEach(pitchers.indices, id: \.self) { i in
                    Button(pitchers[i].name) {
                        selectedPitcherIndex = i
                        selectedPitchType = ""; strikeOrBall = ""
                        selectedLocation = ""; lastPitchInfo = ""
                    }
                }
                Button("Cancel", role: .cancel) {}
            }

            if let idx = selectedPitcherIndex {
                ScrollView {
                    VStack(spacing: 16) {
                        Text("Tracking: \(pitchers[idx].name)").font(.title2)

                        HStack(spacing: 12) {
                            statBox(title: "Pitches", value: "\(pitchers[idx].pitchcount)")
                            statBox(
                                title: "Strike %",
                                value: pitchers[idx].pitchcount == 0
                                    ? "0%" : String(format: "%.0f%%", pitchers[idx].strike * 100)
                            )
                            statBox(title: "Last Pitch", value: lastPitchInfo.isEmpty ? "-" : lastPitchInfo)
                        }
                        .padding(.horizontal)

                        if pitchers[idx].pitches.isEmpty {
                            Text("No pitches set. Edit pitcher to add pitches.")
                                .font(.subheadline).multilineTextAlignment(.center)
                                .foregroundColor(.gray).padding(.horizontal)
                        } else {
                            Text("Pitch Type").font(.headline)
                            LazyVGrid(columns: pitchColumns, spacing: 10) {
                                ForEach(pitchers[idx].pitches, id: \.self) { pitch in
                                    Button { selectedPitchType = pitch } label: {
                                        Text(pitch).font(.caption).padding(8)
                                            .frame(maxWidth: .infinity)
                                            .background(selectedPitchType == pitch ? .blue : .gray.opacity(0.3))
                                            .foregroundColor(.white)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }

                        HStack {
                            Button { strikeOrBall = "Strike" } label: {
                                Text("Strike").padding().frame(maxWidth: .infinity)
                                    .background(strikeOrBall == "Strike" ? .green : .gray.opacity(0.3))
                                    .foregroundColor(.white).clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            Button { strikeOrBall = "Ball" } label: {
                                Text("Ball").padding().frame(maxWidth: .infinity)
                                    .background(strikeOrBall == "Ball" ? .red : .gray.opacity(0.3))
                                    .foregroundColor(.white).clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        .padding(.horizontal)

                        Text("Choose Pitch Location").font(.subheadline)
                        VStack(spacing: 10) {
                            ForEach(0..<zoneButtons.count, id: \.self) { row in
                                HStack(spacing: 10) {
                                    ForEach(0..<zoneButtons[row].count, id: \.self) { col in
                                        let zone = zoneButtons[row][col]
                                        Button { selectedLocation = zone } label: {
                                            Text(zone).font(.caption).padding(8)
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

                        Button{ savePitch()} label:{
                            Text("Save Pitch").frame(maxWidth: .infinity).padding()
                                .background(.blue).foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12)).padding(.horizontal)
                        }
                        .disabled(selectedPitchType.isEmpty || strikeOrBall.isEmpty ||
                                  selectedLocation.isEmpty || selectedPitcherIndex == nil)
                    }
                }
            }

            Spacer()
        }
    }

    func statBox(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.caption).foregroundColor(.gray)
            Text(value).font(.headline).lineLimit(2).minimumScaleFactor(0.7)
        }
        .padding(8).frame(maxWidth: .infinity)
        .background(Color(.systemGray6)).clipShape(RoundedRectangle(cornerRadius: 10))
    }

    func savePitch() {
        guard let idx = selectedPitcherIndex else { return }
        let oldCount = store.teams[teamIndex].pitchers[idx].pitchcount
        store.teams[teamIndex].pitchers[idx].pitchcount += 1
        let prevStrikes = Int(round(store.teams[teamIndex].pitchers[idx].strike * Double(max(oldCount, 1))))
        let newStrikes = strikeOrBall == "Strike" ? prevStrikes + 1 : prevStrikes
        store.teams[teamIndex].pitchers[idx].strike =
            Double(newStrikes) / Double(store.teams[teamIndex].pitchers[idx].pitchcount)

        lastPitchInfo = "\(selectedPitchType) • \(strikeOrBall) • \(selectedLocation)"
        selectedPitchType = ""; strikeOrBall = ""; selectedLocation = ""
    }
}
