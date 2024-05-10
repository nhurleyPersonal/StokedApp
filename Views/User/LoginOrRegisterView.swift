import SwiftUI

struct LoginOrRegisterView: View {
    @State private var username = ""
    @State private var password = ""

    var onLogin: () -> Void

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    NavigationLink(destination: LoginView(onLogin: {})) {
                        Text("Login")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    NavigationLink(destination: RegisterView(onLogin: {})) {
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
    }
}

struct LoginOrRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        LoginOrRegisterView(onLogin: {})
    }
}
