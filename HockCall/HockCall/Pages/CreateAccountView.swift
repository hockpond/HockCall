import CryptoKit
import SwiftData
import SwiftUI

struct CreateAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?

    private var trimmedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var trimmedUsername: String {
        username.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var isCreateAccountButtonDisabled: Bool {
        trimmedEmail.isEmpty
            || !isEmailValid
            || trimmedUsername.isEmpty
            || password.isEmpty
            || confirmPassword.isEmpty
            || password != confirmPassword
            || isLoading
    }

    private var formInputSignature: String {
        "\(email)|\(username)|\(password)|\(confirmPassword)"
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
                            textContentType: .newPassword,
                            accessibilityIdentifier: "createAccountPasswordField"
                        )
                        AppTextInputField(
                            title: "Confirm Password",
                            placeholder: "Confirm Password",
                            text: $confirmPassword,
                            isSecure: true,
                            isDisabled: isLoading,
                            textContentType: .newPassword,
                            accessibilityIdentifier: "createAccountConfirmPasswordField"
                        )
                    }

                    if let errorMessage {
                        Text(errorMessage)
                            .font(.system(size: 15))
                            .foregroundStyle(.red)
                            .accessibilityIdentifier("createAccountErrorMessage")
                    }

                    AppPrimaryButton(
                        isDisabled: isCreateAccountButtonDisabled,
                        accessibilityIdentifier: "createAccountSubmitButton",
                        action: {
                            Task {
                                createAccount()
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
        .onChange(of: formInputSignature) { _, _ in
            errorMessage = nil
        }
        .accessibilityIdentifier("createAccountView")
    }

    private var isEmailValid: Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: trimmedEmail)
    }

    private func createAccount() {
        isLoading = true
        errorMessage = nil

        let email = trimmedEmail
        let username = trimmedUsername

        self.email = email
        self.username = username

        guard isEmailValid else {
            errorMessage = "Enter a valid email address."
            isLoading = false
            return
        }
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            isLoading = false
            return
        }

        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate<User> {
                $0.email == email || $0.username == username
            }
        )

        do {
            let existingUsers = try modelContext.fetch(descriptor)
            if !existingUsers.isEmpty {
                errorMessage = "An account with that email or username already exists."
                isLoading = false
                return
            }

            let passwordHash = hashPassword(password)
            let user = User(email: email, username: username, passwordHash: passwordHash)
            modelContext.insert(user)
            try modelContext.save()

            isLoading = false
            dismiss()
        } catch {
            errorMessage = "Unable to create account right now. Please try again."
            isLoading = false
        }
    }

    private func hashPassword(_ password: String) -> String {
        let digest = SHA256.hash(data: Data(password.utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
    }

}

#Preview {
    NavigationStack {
        CreateAccountView()
    }
}
