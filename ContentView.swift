import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: DataStore
    @State private var showingAlert = false
    @State private var newTeamName = ""

    var body: some View {
        NavigationStack {
            VStack {
                Text("Your Teams")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.top)

                if store.teams.isEmpty {
                    Spacer()
                    Text("No teams yet.")
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                } else {
                    List {
                        ForEach(store.teams.indices, id: \.self) { index in
                            NavigationLink(destination: HomeView(teamIndex: index)) {
                                Text(store.teams[index].name)
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
                        let trimmed = newTeamName.trimmingCharacters(in: .whitespaces)
                        if !trimmed.isEmpty {
                            store.teams.append(Teams(name: trimmed))
                            newTeamName = ""
                        }
                    }
                    Button("Cancel", role: .cancel) { newTeamName = "" }
                }
            }
        }
    }

    func deleteTeam(at offsets: IndexSet) {
        store.teams.remove(atOffsets: offsets)
    }
}
