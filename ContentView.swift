import SwiftUI

struct ContentView: View {
    @State private var teams: [Teams] = []
    @State private var showingAlert = false
    @State private var newTeamName = ""

    var body: some View {
        NavigationStack {
            VStack {
                Text("Your Teams")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.top)

                if teams.isEmpty {
                    Spacer()
                    Text("No teams yet.")
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                } else {
                    List {
                        ForEach(teams, id: \.name) { team in
                            NavigationLink(destination: HomeView(team: team)) {
                                Text(team.name)
                            }
                        }
                        .onDelete(perform: deleteTeam)
                    }
                }

                Button {
                    showingAlert = true
                } label: {
                    Text("Add New Team")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding()
                }
                .alert("Add Team", isPresented: $showingAlert) {
                    TextField("Enter team name", text: $newTeamName)
                    Button("Save") {
                        if !newTeamName.trimmingCharacters(in: .whitespaces).isEmpty {
                            let team = Teams(name: newTeamName)
                            teams.append(team)
                            newTeamName = ""
                        }
                    }
                    Button("Cancel", role: .cancel) {
                        newTeamName = ""
                    }
                }
            }
        }
    }

    func deleteTeam(at offsets: IndexSet) {
        teams.remove(atOffsets: offsets)
    }
}
