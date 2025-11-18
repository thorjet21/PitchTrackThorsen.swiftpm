import SwiftUI

struct PitcherView: View {
    @State var pitchers: [Pitchers] = []
    @State var showAddView = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                
                Spacer()
                Button {
                    showAddView = true
                } label: {
                    Text("Add Pitcher")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                }
                .sheet(isPresented: $showAddView) {
                    AddPitcherView { newPitcher in
                        pitchers.append(newPitcher)
                    }
                }

                NavigationLink(destination: OverView(pitchers: pitchers)) {
                    Text("Pitcher Overview")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                }

                NavigationLink(destination: BullpenView()) {
                    Text("Bullpen")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                }

                NavigationLink(destination: GameView()) {
                    Text("Start Tracking")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                }

                Spacer()
            }
        }
    }
}
