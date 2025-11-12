//
//  SwiftUIView.swift
//  PitchTrackThorsen
//
//  Created by NIKLAS THORSEN on 11/12/25.
//

import SwiftUI

struct GameView: View {
    var body: some View {
        VStack {
            Text("Game Tracking")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.top)

            Spacer()
            Text("This is where pitch tracking will happen.")
                .foregroundColor(.gray)
            Spacer()
        }
    }
}
