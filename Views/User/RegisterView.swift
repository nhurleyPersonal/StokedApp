import SwiftUI

struct RegisterView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""

    var onLogin: () -> Void

    var body: some View {
        ZStack {
            Color(hex: "212121")
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Register")
                    .font(.system(size: 36))
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                HStack {
                    TextField("First Name", text: $firstName)
                        .padding()
                        .border(Color.gray, width: 0.5)
                        .background(.white)

                    TextField("Last Name", text: $lastName)
                        .padding()
                        .border(Color.gray, width: 0.5)
                        .background(.white)
                }

                TextField("Email", text: $email)
                    .padding()
                    .border(Color.gray, width: 0.5)
                    .background(.white)

                SecureField("Password", text: $password)
                    .padding()
                    .border(Color.gray, width: 0.5)
                    .background(.white)

                Button(action: {
                    // Handle registration
                    print("Registering user with first name \(firstName), last name \(lastName), email \(email), and password \(password)")
                }) {
                    Text("Register")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(onLogin: {})
    }
}
