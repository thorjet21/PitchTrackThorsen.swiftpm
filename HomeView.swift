//
//  SwiftUIView.swift
//  PitchTrackThorsen
//
//  Created by NIKLAS THORSEN on 11/10/25.
//

import SwiftUI

struct HomeView: View {
    var team: Teams
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            Text(team.name)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.top)
            
            Spacer()

            TabView(selection: $selectedTab) {
                HomeTab(team: team)
                    .tag(0)
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }

                TeamView()
                    .tag(1)
                    .tabItem {
                        Label("Team", systemImage: "person.3.fill")
                    }

                PitcherView()
                    .tag(2)
                    .tabItem {
                        Label("Pitching", systemImage: "figure.baseball")
                    }
            }
        }
        .navigationBarBackButtonHidden(false)
    }
}

struct HomeTab: View {
    var team: Teams

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

#Preview {
    HomeView(team: Teams(name: "Demo Team"))
}
