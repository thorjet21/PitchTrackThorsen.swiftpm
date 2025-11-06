import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Your Teams")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.horizontal)

                Spacer()

                Button {
                    // action here
                } label: {
                    Text("Add New Team")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .padding(.horizontal)
                }
                .buttonStyle(.plain)
            }
        }
    }
}
