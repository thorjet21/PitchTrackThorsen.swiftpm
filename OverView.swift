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

    @State private var selectedTab = 0
    @State private var showingAddPitcher = false

    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $selectedTab) {
                Text("Bullpen").tag(0)
                Text("Games").tag(1)
            }
            .pickerStyle(.segmented)
            .padding()

            if selectedTab == 0 {
                BullpenStatsTab(teamIndex: teamIndex, showingAddPitcher: $showingAddPitcher)
            } else {
                GamesHistoryTab(teamIndex: teamIndex)
            }
        }
        .navigationTitle("Overview")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if selectedTab == 0 {
                    Button { showingAddPitcher = true } label: {
                        Image(systemName: "plus")
                    }
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
