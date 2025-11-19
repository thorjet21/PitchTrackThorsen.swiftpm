//
//  SwiftUIView.swift
//  PitchTrackThorsen
//
//  Created by NIKLAS THORSEN on 11/12/25.
//

import SwiftUI

import SwiftUI

struct BullpenView: View {
    @State var pitchers: [Pitchers] = []
    @State private var showingPicker = false
    @State private var selectedPitcher: Pitchers? = nil
    @State private var selectedPitchType = ""
    @State private var strikeOrBall = ""
    @State private var pitchLocation: CGPoint? = nil

    let pitchTypes = ["Fastball", "Curveball", "Slider", "Changeup", "Cutter", "Sinker"]

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

                    ZStack {
                        Rectangle()
                            .stroke(Color.black, lineWidth: 2)
                            .frame(width: 200, height: 250)
                            .onTapGesture { location in
                                pitchLocation = location
                            }

                        if let loc = pitchLocation {
                            Circle()
                                .fill(.blue)
                                .frame(width: 14, height: 14)
                                .position(loc)
                        }
                    }

                    Button {
                     
                    } label: {
                        Text("Save Pitch")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.blue)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal)
                    }
                }
            }

            Spacer()
        }
    }
}
