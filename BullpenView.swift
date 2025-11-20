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
    @State var pitchLocation: CGPoint? = nil

    private let pitchTypes = ["Fastball", "Curveball", "Slider", "Changeup", "Cutter", "Sinker"]

    var body: some View {
        VStack(spacing: 20) {
            Text("Bullpen")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.top)

            Spacer(minLength: 10)

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
                    }
                }
                Button("Cancel", role: .cancel) {}
            }

            if let pitcher = selectedPitcher {
                VStack(spacing: 16) {

                    Text("Tracking: \(pitcher.name)")
                        .font(.title2)

                    // Pitch type chooser
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(pitchTypes, id: \.self) { pitch in
                                Button {
                                    selectedPitchType = pitch
                                } label: {
                                    Text(pitch)
                                        .padding(10)
                                        .background(selectedPitchType == pitch ? .blue : .gray.opacity(0.3))
                                        .foregroundColor(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Strike / Ball buttons
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

                    Text("Tap the zone to mark location")
                        .font(.subheadline)

                    // Strike zone with tap location support
                    GeometryReader { geo in
                        ZStack {
                            let zoneWidth: CGFloat = 200
                            let zoneHeight: CGFloat = 250

                            Rectangle()
                                .stroke(Color.black, lineWidth: 2)
                                .frame(width: zoneWidth, height: zoneHeight)
                                .contentShape(Rectangle())
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { value in
                                            let frame = CGRect(
                                                x: (geo.size.width - zoneWidth) / 2,
                                                y: (geo.size.height - zoneHeight) / 2,
                                                width: zoneWidth,
                                                height: zoneHeight
                                            )

                                            if frame.contains(value.location) {
                                                let pointInZone = CGPoint(
                                                    x: value.location.x, //- frame.origin.x,
                                                    y: value.location.y - frame.origin.y
                                                )
                                                pitchLocation = pointInZone
                                            }
                                        }
                                )

                            if let loc = pitchLocation {
                                Circle()
                                    .fill(.blue)
                                    .frame(width: 14, height: 14)
                                    .position(
                                        x: (geo.size.width - zoneWidth) / 2 + loc.x,
                                        y: (geo.size.height - zoneHeight) / 2 + loc.y
                                    )
                            }
                        }
                    }
                    .frame(height: 260)

                    // Save Pitch button
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
                        selectedPitcher == nil ||
                        selectedPitchType.isEmpty ||
                        strikeOrBall.isEmpty ||
                        pitchLocation == nil
                    )
                }
            }

            Spacer()
        }
    }

    private func savePitch() {
        guard var pitcher = selectedPitcher,
              !selectedPitchType.isEmpty,
              !strikeOrBall.isEmpty,
              pitchLocation != nil
        else { return }

        // increment pitch count
        let oldPitchCount = pitcher.pitchcount
        pitcher.pitchcount += 1

        // approximate strike percentage
        let previousStrikes = Int(round(pitcher.strike * Double(max(oldPitchCount, 1))))
        let newStrikes = strikeOrBall == "Strike" ? previousStrikes + 1 : previousStrikes
        let newStrikePercent = Double(newStrikes) / Double(pitcher.pitchcount)
        pitcher.strike = newStrikePercent

        // push updated pitcher back into shared array so UI updates
        if let index = pitchers.firstIndex(where: { $0.id == pitcher.id }) {
            pitchers[index] = pitcher
            selectedPitcher = pitchers[index]
        }
    }
}
