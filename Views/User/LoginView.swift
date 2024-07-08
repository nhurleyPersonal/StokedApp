import SwiftUI

struct LoginView: View {
    var onLogin: () -> Void
    let isLoggedIn: Bool

    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false

    var body: some View {
        ZStack {
            Color(hex: "212121")
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.bottom, 20)
                    .foregroundColor(.white)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress) // Set the keyboard type to email
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                Button(action: {
                    UserAPI.shared.login(email: self.email, password: self.password) { success, _ in
                        if success {
                            self.onLogin()
                        } else {
                            self.showingAlert = true
                        }
                    }
                }) {
                    Text("Log In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color.blue)
                        .cornerRadius(15.0)
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Login Failed"), message: Text("Invalid username or password."), dismissButton: .default(Text("OK")))
                }
                // New Register Button
                NavigationLink(destination: RegisterView(onLogin: onLogin)) {
                    Text("Don't have an account yet? Register now")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .padding(.top, 20)
                }
            }
            .padding()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(onLogin: {}, isLoggedIn: true)
    }
}
