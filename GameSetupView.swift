//
//  SwiftUIView.swift
//  PitchTrackThorsen
//
//  Created by NIKLAS THORSEN on 5/7/26.
//

import SwiftUI

struct GameSetupView: View {
    @EnvironmentObject var store: DataStore
    let teamIndex: Int
    @Binding var opponentName: String
    @Binding var selectedPitcherIndex: Int?
    @Binding var isNewOpponent: Bool
    let pastOpponents: [String]
    let pitchers: [Pitchers]
    let onStart: () -> Void

    var canStart: Bool {
        !opponentName.trimmingCharacters(in: .whitespaces).isEmpty && selectedPitcherIndex != nil
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("New Game")
                    .font(.largeTitle).fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top)

                // Opponent
                VStack(alignment: .leading, spacing: 12) {
                    Text("Opponent").font(.headline)

                    Picker("", selection: $isNewOpponent) {
                        Text("New Team").tag(true)
                        Text("Previous Opponent").tag(false)
                    }
                    .pickerStyle(.segmented)

                    if isNewOpponent || pastOpponents.isEmpty {
                        TextField("Enter team name", text: $opponentName)
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(pastOpponents, id: \.self) { opp in
                                    Button {
                                        opponentName = opp
                                    } label: {
                                        Text(opp)
                                            .font(.subheadline)
                                            .padding(.horizontal, 14).padding(.vertical, 8)
                                            .background(opponentName == opp ? Color.blue : Color(.systemGray5))
                                            .foregroundColor(opponentName == opp ? .white : .primary)
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)

                // Pitcher
                VStack(alignment: .leading, spacing: 12) {
                    Text("Starting Pitcher").font(.headline)

                    if pitchers.isEmpty {
                        Text("No pitchers added. Go to Pitcher Overview to add one.")
                            .font(.subheadline).foregroundColor(.gray)
                    } else {
                        ForEach(pitchers.indices, id: \.self) { i in
                            Button {
                                selectedPitcherIndex = i
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(pitchers[i].name).font(.headline)
                                        Text(pitchers[i].pitches.joined(separator: " · "))
                                            .font(.caption).foregroundColor(.gray)
                                    }
                                    Spacer()
                                    if selectedPitcherIndex == i {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding()
                                .background(selectedPitcherIndex == i ? Color.blue.opacity(0.1) : Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selectedPitcherIndex == i ? Color.blue : Color.clear, lineWidth: 1.5)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal)

                Button(action: onStart) {
                    Text("Start Tracking")
                        .font(.headline).frame(maxWidth: .infinity).padding()
                        .background(canStart ? Color.blue : Color.gray.opacity(0.4))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(!canStart)
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
    }
}
