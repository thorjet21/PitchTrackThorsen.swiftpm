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

    @State private var showingNewOpponent = false

    var canStart: Bool {
        !opponentName.trimmingCharacters(in: .whitespaces).isEmpty && selectedPitcherIndex != nil
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {

                Text("New Game")
                    .font(.largeTitle).fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top)

                // Opponent
                VStack(alignment: .leading, spacing: 10) {
                    Text("Opponent").font(.headline).padding(.horizontal)

                    if pastOpponents.isEmpty {
                        TextField("Enter team name", text: $opponentName)
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal)
                    } else {
                        ForEach(pastOpponents, id: \.self) { opp in
                            Button {
                                opponentName = opp
                            } label: {
                                HStack {
                                    Text(opp).font(.subheadline)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    if opponentName == opp {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding()
                                .background(opponentName == opp ? Color.blue.opacity(0.1) : Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal)
                        }

                        Button {
                            showingNewOpponent = true
                        } label: {
                            HStack {
                                Image(systemName: "plus.circle")
                                Text("Add new opponent")
                                Spacer()
                            }
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal)
                        }
                    }
                }

                // Pitcher
                VStack(alignment: .leading, spacing: 10) {
                    Text("Starting Pitcher").font(.headline).padding(.horizontal)

                    if pitchers.isEmpty {
                        Text("No pitchers added. Go to Pitcher Overview to add one.")
                            .font(.subheadline).foregroundColor(.gray).padding(.horizontal)
                    } else {
                        ForEach(pitchers.indices, id: \.self) { i in
                            Button {
                                selectedPitcherIndex = i
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(pitchers[i].name).font(.headline)
                                            .foregroundColor(.primary)
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
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal)
                        }
                    }
                }

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
        .alert("New Opponent", isPresented: $showingNewOpponent) {
            TextField("Enter team name", text: $opponentName)
            Button("Add") {}
            Button("Cancel", role: .cancel) { opponentName = "" }
        }
    }
}
