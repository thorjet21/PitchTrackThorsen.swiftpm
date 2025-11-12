//
//  SwiftUIView.swift
//  PitchTrackThorsen
//
//  Created by NIKLAS THORSEN on 11/12/25.
//

import SwiftUI

struct OverView: View {
    var pitchers: [Pitchers]

    var body: some View {
        VStack {
            Text("Pitcher Overview")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.top)

            if pitchers.isEmpty {
                Spacer()
                Text("No pitchers added yet.")
                    .foregroundColor(.gray)
                Spacer()
            } else {
                List(pitchers, id: \.name) { pitcher in
                    Text(pitcher.name)
                }
            }
        }
    }
}
