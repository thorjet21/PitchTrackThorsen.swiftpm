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
    @State var selectedPitches: Set<String> = []
    
    private let allPitchNames = [
        "Fastball", "Curveball", "Slider", "Changeup",
        "Cutter", "Sinker", "Splitter", "Knuckleball"
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
                
                ForEach(allPitchNames, id: \.self) { pitch in
                    Toggle(pitch, isOn: Binding(
                        get: { selectedPitches.contains(pitch) },
                        set: { selectedPitches.insert(pitch); if !$0 { selectedPitches.remove(pitch) } }
                    ))
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button {
                let newPitcher = Pitchers(
                    name: name.isEmpty ? "New Pitcher" : name,
                    pitches: Array(selectedPitches)
                )
                onSave(newPitcher)
                dismiss()
            } label: {
                Text("Save")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(name.isEmpty ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
            }
            .disabled(name.isEmpty)
        }
    }
}
