//
//  SwiftUIView.swift
//  PitchTrackThorsen
//
//  Created by Niklas Thorsen on 11/16/25.
//

import SwiftUI

struct EditView: View {
    @Binding var pitcher: Pitchers

    @State var pitchTypes: [PitchType] = [
        PitchType(name: "Fastball", isOn: false),
        PitchType(name: "Curveball", isOn: false),
        PitchType(name: "Slider", isOn: false),
        PitchType(name: "Changeup", isOn: false),
        PitchType(name: "Cutter", isOn: false),
        PitchType(name: "Sinker", isOn: false),
        PitchType(name: "Splitter", isOn: false),
        PitchType(name: "Knuckleball", isOn: false)
    ]
    var body: some View {
        VStack(spacing: 20) {
            Text("Edit Pitcher")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.top)

            TextField("Pitcher name", text: $pitcher.name)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)

            VStack(alignment: .leading, spacing: 10) {
                Text("Pitches")
                    .font(.headline)

                ForEach($pitchTypes) { $pitch in
                    Toggle(pitch.name, isOn: $pitch.isOn)
                }
            }
            .padding(.horizontal)

            Spacer()

            Button {
                //pitcher.pitches = pitchTypes.filter { $0.value }.map { $0.key }
            } label: {
                Text("Save Changes")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
            }
        }
        .onAppear {
            // load current pitches into toggles
            //for key in pitchTypes.keys {
                //pitchTypes[key] = pitcher.pitches.contains(key)
            //}
        }
    }
}
