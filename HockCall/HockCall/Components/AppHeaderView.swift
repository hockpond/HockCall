import SwiftUI

struct AppHeaderView: View {
    var body: some View {
        HStack {
            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 75, height: 75)

            VStack(alignment: .leading) {
                Text("RaidCall")
                    .font(.largeTitle)
                    .bold()

                Text("The Inner Voice")
                    .font(.subheadline)
                    .tracking(1.7)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 180)
        .background(
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(red: 0.20, green: 0.55, blue: 0.90), location: 0.0),
                    .init(color: Color(red: 0.65, green: 0.82, blue: 0.96), location: 0.45),
                    .init(color: Color.white, location: 0.8)
                ]),
                startPoint: .top,
                endPoint: .bottom,
            )
        )
    }
}

#Preview {
    AppHeaderView()
}
