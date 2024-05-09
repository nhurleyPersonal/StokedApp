import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var showingAlert = false

    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.bottom, 20)
            TextField("Username", text: $username)
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
                // Implement login functionality here
                print("Login button tapped")
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
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
