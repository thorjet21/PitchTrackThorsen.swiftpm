//
//  SwiftUIView.swift
//  PitchTrackThorsen
//
//  Created by Niklas Thorsen on 11/16/25.
//

import SwiftUI

struct EditView: View {
    @Binding var pitcher: Pitchers
    
    private let allPitchNames = [
        "Fastball", "Curveball", "Slider", "Changeup",
        "Cutter", "Sinker", "Splitter", "Knuckleball"
    ]
    
    @Environment(\.dismiss) var dismiss
    @State var selectedPitches: Set<String> = []
    
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
                
                ForEach(allPitchNames, id: \.self) { pitchName in
                    Toggle(pitchName, isOn: Binding(
                        get: { selectedPitches.contains(pitchName) },
                        set: { isOn in
                            if isOn {
                                selectedPitches.insert(pitchName)
                            } else {
                                selectedPitches.remove(pitchName)
                            }
                        }
                    ))
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            Button {
                pitcher.pitches = Array(selectedPitches)
                dismiss()
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
            selectedPitches = Set(pitcher.pitches)
        }
    }
}
