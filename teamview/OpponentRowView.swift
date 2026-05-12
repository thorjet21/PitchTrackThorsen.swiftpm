//
//  SwiftUIView.swift
//  PitchTrackThorsen
//
//  Created by Niklas Thorsen on 5/11/26.
//

import SwiftUI

struct OpponentRowView: View {
    let summary: OpponentSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(summary.name).font(.headline)
                Spacer()
                if let last = summary.lastPlayed {
                    Text(last, style: .date)
                        .font(.caption).foregroundColor(.gray)
                }
            }

            HStack(spacing: 16) {
                Label(
                    "\(summary.gameCount) \(summary.gameCount == 1 ? "game" : "games")",
                    systemImage: "calendar"
                )
                .font(.caption).foregroundColor(.secondary)

                Label(
                    "\(summary.pitcherSummaries.count) \(summary.pitcherSummaries.count == 1 ? "pitcher" : "pitchers")",
                    systemImage: "figure.baseball"
                )
                .font(.caption).foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
