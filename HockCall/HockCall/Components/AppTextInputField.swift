import SwiftUI

struct AppTextInputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var isDisabled: Bool = false
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType?
    var accessibilityIdentifier: String?

    var body: some View {
        VStack(alignment: .leading) {
            FieldLabel(title: title)

            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .textContentType(textContentType)
                } else {
                    TextField(placeholder, text: $text)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .keyboardType(keyboardType)
                        .textContentType(textContentType)
                }
            }
            .padding(.horizontal, 12)
            .frame(height: 52)
            .background(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(.gray.opacity(0.7), lineWidth: 1)
            )
            .disabled(isDisabled)
            .applyAccessibilityIdentifier(accessibilityIdentifier)
        }
    }
}

extension View {
    @ViewBuilder
    func applyAccessibilityIdentifier(_ identifier: String?) -> some View {
        if let identifier {
            accessibilityIdentifier(identifier)
        } else {
            self
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        AppTextInputField(title: "Username", placeholder: "Username", text: .constant(""))
        AppTextInputField(
            title: "Password",
            placeholder: "Password",
            text: .constant(""),
            isSecure: true
        )
    }
    .padding()
}
