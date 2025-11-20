//
//  SwiftUIView.swift
//  PitchTrackThorsen
//
//  Created by NIKLAS THORSEN on 11/12/25.
//

import SwiftUI

struct OverView: View {
    @Binding var pitchers: [Pitchers]

    var body: some View {
        ZStack {
            if pitchers.isEmpty {
                VStack {
                    Text("No pitchers added yet")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
            } else {
                List {
                    ForEach(pitchers.indices, id: \.self) { index in
                        NavigationLink(destination: EditView(pitcher: $pitchers[index])) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(pitchers[index].name)
                                    .font(.headline)

                                Text("Pitches: \(pitchers[index].pitches.joined(separator: ", "))")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)

                                Text("Pitch Count: \(pitchers[index].pitchcount)")
                                    .font(.subheadline)

                                Text("Innings: \(String(format: "%.1f", pitchers[index].inning))")
                                    .font(.subheadline)

                                Text("ERA: \(String(format: "%.3f", pitchers[index].era))")
                                    .font(.subheadline)

                                Text("Strike %: \(String(format: "%.3f", pitchers[index].strike))")
                                    .font(.subheadline)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
        }
        .navigationTitle("Pitchers")
    }
}
