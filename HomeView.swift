//
//  SwiftUIView.swift
//  PitchTrackThorsen
//
//  Created by NIKLAS THORSEN on 11/10/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: DataStore
    let teamIndex: Int
    @State var selectedTab = 0

    var body: some View {
        VStack(spacing: 0) {
            Text(store.teams[teamIndex].name)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.top)

            Spacer()

            TabView(selection: $selectedTab) {
                HomeTab(teamIndex: teamIndex)
                    .tag(0)
                    .tabItem { Label("Home", systemImage: "house.fill") }

                TeamView()
                    .tag(1)
                    .tabItem { Label("Team", systemImage: "person.3.fill") }

                PitcherView(teamIndex: teamIndex)
                    .tag(2)
                    .tabItem { Label("Pitching", systemImage: "figure.baseball") }
            }
        }
        .navigationBarBackButtonHidden(false)
    }
}

struct HomeTab: View {
    let teamIndex: Int
    var body: some View {
        VStack {
            Spacer()
            Text("No Games have been added")
                .font(.title3)
                .foregroundColor(.gray)
            Spacer()
        }
    }
}
