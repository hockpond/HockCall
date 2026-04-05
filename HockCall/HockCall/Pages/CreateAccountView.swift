import SwiftUI

struct CreateAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isLoading: Bool = false
    private var isCreateAccountButtonDisabled: Bool {
        email.isEmpty || !isEmailValid || username.isEmpty || password.isEmpty || confirmPassword.isEmpty || isLoading
    }

    var body: some View {
        VStack(spacing: 0) {
            AppHeaderView()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        AppTextInputField(
                            title: "Email",
                            placeholder: "Email",
                            text: $email,
                            isDisabled: isLoading,
                            keyboardType: .emailAddress,
                            textContentType: .emailAddress,
                            accessibilityIdentifier: "createAccountEmailField"
                        )
                        AppTextInputField(
                            title: "Username",
                            placeholder: "Username",
                            text: $username,
                            isDisabled: isLoading,
                            accessibilityIdentifier: "createAccountUsernameField"
                        )
                        AppTextInputField(
                            title: "Password",
                            placeholder: "Password",
                            text: $password,
                            isSecure: true,
                            isDisabled: isLoading,
                            accessibilityIdentifier: "createAccountPasswordField"
                        )
                        AppTextInputField(
                            title: "Confirm Password",
                            placeholder: "Confirm Password",
                            text: $confirmPassword,
                            isSecure: true,
                            isDisabled: isLoading,
                            accessibilityIdentifier: "createAccountConfirmPasswordField"
                        )
                    }

                    AppPrimaryButton(
                        isDisabled: isCreateAccountButtonDisabled,
                        accessibilityIdentifier: "createAccountSubmitButton",
                        action: {
                            Task {
                                await createAccount()
                            }
                        },
                        label: {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .tint(.gray)
                                }

                                Text(isLoading ? "Creating Account..." : "Create Account")
                                    .font(.system(size: 23))
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 13)
                            }
                        }
                    )
                    .padding(.top, 8)

                    HStack {
                        FieldLabel(title: "Already have an account?")
                        Button {
                            dismiss()
                        } label: {
                            Text("Sign In")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(24)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .accessibilityIdentifier("createAccountView")
    }

    private var isEmailValid: Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    private func createAccount() async {
        isLoading = true

        try? await Task.sleep(for: .seconds(2))

        isLoading = false
    }

}

#Preview {
    NavigationStack {
        CreateAccountView()
    }
}
