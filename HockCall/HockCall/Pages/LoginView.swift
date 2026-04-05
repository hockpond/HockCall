import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    @State private var rememberMe: Bool = false
    @State private var signInAutomatically: Bool = false

    var body: some View {
        VStack {
            AppHeaderView()

            VStack {
                AppTextInputField(
                    title: "Username",
                    placeholder: "Username",
                    text: $username,
                    isDisabled: isLoading,
                    accessibilityIdentifier: "usernameField"
                )

                AppTextInputField(
                    title: "Password",
                    placeholder: "Password",
                    text: $password,
                    isSecure: true,
                    isDisabled: isLoading,
                    accessibilityIdentifier: "passwordField"
                )
                .padding(.top, 15)

                VStack(alignment: .leading, spacing: 9) {
                    Button {
                        rememberMe.toggle()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: rememberMe ? "checkmark.square.fill" : "square")
                            Text("Remember me")
                                .font(.system(size: 19))
                        }
                    }
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("rememberMeButton")

                    Button {
                        signInAutomatically.toggle()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: signInAutomatically ? "checkmark.square.fill" : "square")
                            Text("Sign in automatically")
                                .font(.system(size: 19))
                        }
                    }
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("signInAutomaticallyButton")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 15)
                .padding(.bottom, 30)

                AppPrimaryButton(
                    isDisabled: username.isEmpty || password.isEmpty || isLoading,
                    accessibilityIdentifier: "signInButton"
                ) {
                    Task {
                        await signIn()
                    }
                } label: {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .tint(.gray)
                        }

                        Text(isLoading ? "Signing In..." : "Sign In")
                            .font(.system(size: 23))
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .accessibilityIdentifier("signInButtonLabel")
                    }
                }
            }
            .frame(maxWidth: 360)
            .padding(.horizontal, 30)

            VStack {
                Spacer()

                HStack(spacing: 10) {
                    NavigationLink {
                        CreateAccountView()
                            .accessibilityIdentifier("createAccountView")
                    } label: {
                        HStack {
                            Image("CreateAccount")
                            Text("Create a new account")
                                .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("createAccountButton")

                    Button {
                    } label: {
                        HStack {
                            Image("ForgotPassword")
                            Text("Forgot password?")
                                .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("forgotPasswordButton")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
                .background(.gray.opacity(0.05))
                .overlay(alignment: .top) {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.gray.opacity(0.3))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .navigationBarHidden(true)
    }

    private func signIn() async {
        isLoading = true

        try? await Task.sleep(for: .seconds(2))

        isLoading = false
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
}
