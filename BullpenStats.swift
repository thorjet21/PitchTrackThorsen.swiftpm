//
//  File.swift
//  PitchTrackThorsen
//
//  Created by NIKLAS THORSEN on 5/7/26.
//

import SwiftUI

struct BullpenStatsTab: View {
    @EnvironmentObject var store: DataStore
    let teamIndex: Int
    @Binding var showingAddPitcher: Bool

    var pitchers: [Pitchers] { store.teams[teamIndex].pitchers }

    var body: some View {
        if pitchers.isEmpty {
            VStack {
                Spacer()
                Text("No pitchers added yet").font(.headline).foregroundColor(.gray)
                Button { showingAddPitcher = true } label: {
                    Text("Add Pitcher")
                        .font(.subheadline)
                        .padding(.horizontal, 20).padding(.vertical, 10)
                        .background(Color.blue).foregroundColor(.white)
                        .clipShape(Capsule())
                }
                .padding(.top, 8)
                Spacer()
            }
        } else {
            List {
                ForEach(pitchers.indices, id: \.self) { i in
                    NavigationLink(destination: EditView(teamIndex: teamIndex, pitcherIndex: i)) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(pitchers[i].name).font(.headline)
                            Text(pitchers[i].pitches.joined(separator: " · "))
                                .font(.caption).foregroundColor(.gray)
                            HStack(spacing: 16) {
                                Label("\(pitchers[i].pitchcount) pitches", systemImage: "baseball")
                                    .font(.caption2).foregroundColor(.secondary)
                                Label(
                                    pitchers[i].pitchcount == 0 ? "0% K" :
                                        String(format: "%.0f%% K", pitchers[i].strike * 100),
                                    systemImage: "percent"
                                )
                                .font(.caption2).foregroundColor(.secondary)
                            }
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
}
