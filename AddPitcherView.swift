//
//  SwiftUIView.swift
//  PitchTrackThorsen
//
//  Created by Niklas Thorsen on 11/16/25.
//

import SwiftUI

struct AddPitcherView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var name = ""
    
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
    
    var onSave: (Pitchers) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Add Pitcher")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.top)
            
            TextField("Pitcher name", text: $name)
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
                let selected = pitchTypes
                    .filter { $0.isOn }
                    .map { $0.name }
                
                let new = Pitchers(
                    name: name,
                    pitchcount: 0,
                    inning: 0.0,
                    era: 0.0,
                    strike: 0.0,
                    pitches: selected
                )
                
                onSave(new)
                dismiss()
                
            } label: {
                Text("Save")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
            }
        }
    }
}
