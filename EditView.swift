//
//  SwiftUIView.swift
//  PitchTrackThorsen
//
//  Created by Niklas Thorsen on 11/16/25.
//

import SwiftUI

struct EditView: View {
    @EnvironmentObject var store: DataStore
    @Environment(\.dismiss) var dismiss
    let teamIndex: Int
    let pitcherIndex: Int

    private let allPitchNames = [
        "Fastball", "Curveball", "Slider", "Changeup",
        "Cutter", "Sinker", "Splitter", "Knuckleball"
    ]

    @State private var name = ""
    @State private var selectedPitches: Set<String> = []

    var body: some View {
        VStack(spacing: 20) {
            Text("Edit Pitcher")
                .font(.largeTitle).fontWeight(.semibold).padding(.top)

            TextField("Pitcher name", text: $name)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)

            VStack(alignment: .leading, spacing: 10) {
                Text("Pitches").font(.headline)
                ForEach(allPitchNames, id: \.self) { pitchName in
                    Toggle(pitchName, isOn: Binding(
                        get: { selectedPitches.contains(pitchName) },
                        set: { isOn in
                            if isOn { selectedPitches.insert(pitchName) }
                            else { selectedPitches.remove(pitchName) }
                        }
                    ))
                }
            }
            .padding(.horizontal)

            Spacer()

            Button {
                store.teams[teamIndex].pitchers[pitcherIndex].name = name
                store.teams[teamIndex].pitchers[pitcherIndex].pitches = Array(selectedPitches)
                dismiss()
            } label: {
                Text("Save Changes")
                    .font(.headline).frame(maxWidth: .infinity).padding()
                    .background(Color.blue).foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12)).padding(.horizontal)
            }
        }
        .onAppear {
            name = store.teams[teamIndex].pitchers[pitcherIndex].name
            selectedPitches = Set(store.teams[teamIndex].pitchers[pitcherIndex].pitches)
        }
    }
}
