import SwiftUI

struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    @State private var rememberMe: Bool = false
    @State private var signInAutomatically: Bool = false

    var body: some View {
        VStack {
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

            VStack {
                VStack(alignment: .leading) {
                    Text("Username")
                        .font(.system(size: 19))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    TextField("Username", text: $username)
                        .padding(.horizontal, 12)
                        .frame(height: 52)
                        .background(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(.gray.opacity(0.7), lineWidth: 1)
                        )
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .disabled(isLoading)
                        .accessibilityIdentifier("usernameField")
                }

                VStack(alignment: .leading) {
                    Text("Password")
                        .font(.system(size: 19))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                        .padding(.top, 15)
                    SecureField("Password", text: $password)
                        .padding(.horizontal, 12)
                        .frame(height: 52)
                        .background(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(.gray.opacity(0.7), lineWidth: 1)
                        )
                        .disabled(isLoading)
                        .accessibilityIdentifier("passwordField")
                }

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

                Button {
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
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 6))
                .disabled(username.isEmpty || password.isEmpty || isLoading)
                .accessibilityIdentifier("signInButton")

            }
            .frame(maxWidth: 360)
            .padding(.horizontal, 30)

            VStack {
                Spacer()

                HStack(spacing: 10) {
                    Button {

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
    }

    private func signIn() async {
        isLoading = true

        try? await Task.sleep(for: .seconds(2))

        isLoading = false
    }
}

#Preview {
    ContentView()
}
