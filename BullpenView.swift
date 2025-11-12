//
//  SwiftUIView.swift
//  PitchTrackThorsen
//
//  Created by NIKLAS THORSEN on 11/12/25.
//

import SwiftUI

struct BullpenView: View {
    var body: some View {
        VStack {
            Text("Bullpen")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.top)

            Spacer()
            Text("This is where bullpen info will go.")
                .foregroundColor(.gray)
            Spacer()
        }
    }
}
