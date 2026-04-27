//
//  SwiftUIView.swift
//  PitchTrackThorsen
//
//  Created by NIKLAS THORSEN on 11/12/25.
//

import SwiftUI

struct OverView: View {
    @EnvironmentObject var store: DataStore
    let teamIndex: Int
    @State private var showingAddPitcher = false

    var body: some View {
        ZStack {
            if store.teams[teamIndex].pitchers.isEmpty {
                VStack {
                    Text("No pitchers added yet")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
            } else {
                List {
                    ForEach(store.teams[teamIndex].pitchers.indices, id: \.self) { index in
                        NavigationLink(
                            destination: EditView(teamIndex: teamIndex, pitcherIndex: index)
                        ) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(store.teams[teamIndex].pitchers[index].name)
                                    .font(.headline)
                                Text("Pitches: \(store.teams[teamIndex].pitchers[index].pitches.joined(separator: ", "))")
                                    .font(.subheadline).foregroundColor(.gray)
                                Text("Pitch Count: \(store.teams[teamIndex].pitchers[index].pitchcount)")
                                    .font(.subheadline)
                                Text("Strike %: \(String(format: "%.1f%%", store.teams[teamIndex].pitchers[index].strike * 100))")
                                    .font(.subheadline)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .onDelete { offsets in
                        store.teams[teamIndex].pitchers.remove(atOffsets: offsets)
                    }
                }
            }
        }
        .navigationTitle("Pitchers")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { showingAddPitcher = true } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddPitcher) {
            AddPitcherView { newPitcher in
                store.teams[teamIndex].pitchers.append(newPitcher)
            }
        }
    }
}
