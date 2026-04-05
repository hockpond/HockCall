import SwiftUI

struct FieldLabel: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: 19))
            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
    }
}

#Preview {
    FieldLabel(title: "Email")
}
