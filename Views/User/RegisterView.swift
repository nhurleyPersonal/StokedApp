import SwiftUI

struct RegisterView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""

    @State private var tagline = ""
    @State private var skillLevel = ""
    @State private var boardName = ""
    @State private var boardLength = ""
    @State private var boardVolume = ""
    @State private var selectedBoardOption = ""

    @State private var homeSpot: Spot? = nil
    @State private var isRegistrationComplete = false

    var onLogin: () -> Void
    let textboxColor = "373737"

    func register() {
        let preAddUser = PreAddUser(firstName: firstName,
                                    lastName: lastName, email: email, username: username,
                                    favoriteSpots: [], createdAt: Date(), recentSpots: [],
                                    tagline: tagline, skillLevel: skillLevel, homeSpot: homeSpot)

        UserAPI.shared.register(user: preAddUser, password: password) { success, message in
            if success {
                self.onLogin()
            } else {
                print("Registration failed: \(message)")
            }
        }
    }

    var body: some View {
        ZStack {
            Color(hex: "212121")
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: -1) {
                    Text("Sign Up")
                        .font(.title)
                        .foregroundColor(.white)

                    Text("Register to start logging sessions")
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 10)

                VStack(alignment: .leading) {
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading) {
                            Text("First Name")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                            TextField("Mason", text: $firstName)
                                .padding()
                                .background(Color(hex: textboxColor))
                                .border(Color.white, width: 0.5)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Last Name")
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                            TextField("Ho", text: $lastName)
                                .padding()
                                .background(Color(hex: textboxColor))
                                .border(Color.white, width: 0.5)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.bottom, 10)

                    Text("Email")
                        .foregroundColor(.white)
                        .font(.system(size: 16))

                    TextField("example@example.com", text: $email)
                        .padding()
                        .background(Color(hex: textboxColor))
                        .border(Color.white, width: 0.5)
                        .foregroundColor(.white)
                        .padding(.bottom, 10)

                    Text("Password")
                        .font(.headline)
                        .foregroundColor(.white)
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(hex: textboxColor))
                        .border(Color.white, width: 0.5)
                        .foregroundColor(.white)
                        .padding(.bottom, 10)

                    Text("Display Name")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                    TextField("suddenripper01", text: $username)
                        .padding()
                        .background(Color(hex: textboxColor))
                        .border(Color.white, width: 0.5)
                        .foregroundColor(.white)
                        .padding(.bottom, 10)
                }

                Button(action: {
                    self.isRegistrationComplete = true
                }) {
                    Text("Next")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .background(
                    NavigationLink(destination: RegisterExtraInfoView(tagline: $tagline,
                                                                      skillLevel: $skillLevel, boardName: $boardName,
                                                                      boardLength: $boardLength,
                                                                      boardVolume: $boardVolume, selectedBoardOption: $selectedBoardOption,
                                                                      homeSpot: $homeSpot, register: register), isActive: $isRegistrationComplete)
                    {
                        EmptyView()
                    }
                )
                Spacer()
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
