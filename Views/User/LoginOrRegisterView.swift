import SwiftUI

struct LoginOrRegisterView: View {
    @State private var username = ""
    @State private var password = ""
    

    var onLogin: () -> Void
    let isLoggedIn: Bool

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    NavigationLink(destination: LoginView(onLogin: onLogin, isLoggedIn: isLoggedIn)) {
                        Text("Login")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    NavigationLink(destination: RegisterView(onLogin: onLogin)) {
                        Text("Register")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
        .colorScheme(.dark)
    }
}

struct LoginOrRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        LoginOrRegisterView(onLogin: {}, isLoggedIn: true)
    }
}
