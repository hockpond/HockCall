import SwiftUI

struct AppPrimaryButton<Label: View>: View {
    let isDisabled: Bool
    let accessibilityIdentifier: String?
    let action: () -> Void
    @ViewBuilder let label: () -> Label

    var body: some View {
        Button(action: action) {
            label()
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle(radius: 6))
        .disabled(isDisabled)
        .applyAccessibilityIdentifier(accessibilityIdentifier)
    }
}

#Preview {
    AppPrimaryButton(
        isDisabled: false,
        accessibilityIdentifier: nil,
        action: {},
        label: {
            Text("Continue")
                .font(.system(size: 23))
                .bold()
                .frame(maxWidth: .infinity)
                .padding(.vertical, 13)
        }
    )
    .padding()
}
