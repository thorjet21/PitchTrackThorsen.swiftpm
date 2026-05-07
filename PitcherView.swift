import SwiftUI

struct PitcherView: View {
    @EnvironmentObject var store: DataStore
    let teamIndex: Int

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                NavigationLink(destination: OverView(teamIndex: teamIndex)) {
                    Text("Pitcher Overview")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                }

                NavigationLink(destination: BullpenView(teamIndex: teamIndex)) {
                    Text("Bullpen")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                }

                NavigationLink(destination: GameView( teamIndex: teamIndex)) {
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
