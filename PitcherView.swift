//
//  SwiftUIView.swift
//  PitchTrackThorsen
//
//  Created by NIKLAS THORSEN on 11/11/25.
//

import SwiftUI

struct PitcherView: View {
    @State var pitchers: [Pitchers] = []
    @State var showingAddAlert = false
    @State var newPitcherName = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20){
                Button {
                    showingAddAlert = true
                } label: {
                    Text("Add Pitcher")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                }
                .alert("Add Pitcher", isPresented: $showingAddAlert) {
                    TextField("Enter pitcher's name", text: $newPitcherName)
                    Button("Save") {
                        if !newPitcherName.trimmingCharacters(in: .whitespaces).isEmpty {
                            let newPitcher = Pitchers(
                                name: newPitcherName,
                                pitchcount: 0,
                                inning: 0.0,
                                era: 0.0,
                                strike: 0.0,
                                pitches: []
                            )
                            pitchers.append(newPitcher)
                            newPitcherName = ""
                        }
                    }
                    Button("Cancel", role: .cancel) {
                        newPitcherName = ""
                    }
                }
                
                NavigationLink(destination: OverView(pitchers: pitchers)) {
                    Text("Pitcher Overview")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                }
                
                NavigationLink(destination: BullpenView()) {
                    Text("Bullpen")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                }
                
                NavigationLink(destination: GameView()) {
                    Text("Start Tracking")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                }

            }
        }
    }
}
