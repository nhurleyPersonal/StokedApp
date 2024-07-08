//
//  ProfileSettingsView.swift
//  Stoked
//
//  Created by Noah Hurley on 7/7/24.
//

import SwiftUI

struct ProfileSettingsView: View {
    @State private var newBio = ""
    @State private var newUsername = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showCheckMark = false

    @EnvironmentObject var currentUser: CurrentUser
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @FocusState private var isInputActive: Bool

    var body: some View {
        ZStack {
            Color(hex: "212121")
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isInputActive = false // This will dismiss the keyboard
                }
            ScrollView {
                VStack(alignment: .leading) {
                    Text("New Bio:")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .padding(.bottom, 5)

                    TextField("Enter new bio", text: $newBio)
                        .focused($isInputActive)
                        .padding()
                        .background(Color(hex: "373737"))
                        .border(Color.white, width: 0.5)
                        .foregroundColor(.white)
                        .padding(.bottom, 15)

                    Button(action: {
                        updateBio()
                    }) {
                        HStack {
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                            Text("Submit Bio")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color.green))
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                    .padding(.bottom, 15)

                    Text("New Username:")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .padding(.bottom, 5)

                    TextField("Enter new username", text: $newUsername)
                        .focused($isInputActive)
                        .padding()
                        .background(Color(hex: "373737"))
                        .border(Color.white, width: 0.5)
                        .foregroundColor(.white)
                        .padding(.bottom, 15)

                    Button(action: {
                        updateUsername()
                    }) {
                        HStack {
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                            Text("Submit Username")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color.green))
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }

                    Spacer()
                }
                .padding()
            }
            .gesture(
                DragGesture().onChanged { _ in
                    isInputActive = false // Dismiss the keyboard when starting to drag
                }
            )
            .navigationBarTitle("Edit Profile", displayMode: .inline)

            if showCheckMark {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
                    .transition(.scale)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            withAnimation {
                                self.showCheckMark = false
                            }
                        }
                    }
            }
        }
    }

    func updateBio() {
        if !newBio.isEmpty {
            UserAPI.shared.updateUserBio(newBio: newBio) { success, message in
                if success {
                    DispatchQueue.main.async {
                        self.currentUser.user?.tagline = self.newBio
                        withAnimation {
                            self.showCheckMark = true
                        }
                        self.presentationMode.wrappedValue.dismiss()
                    }
                } else {
                    alertMessage = message ?? "Failed to update bio."
                    showingAlert = true
                }
            }
        }
    }

    func updateUsername() {
        if !newUsername.isEmpty {
            UserAPI.shared.updateUsername(newUsername: newUsername) { success, message in
                if success {
                    DispatchQueue.main.async {
                        self.currentUser.user?.username = self.newUsername
                        withAnimation {
                            self.showCheckMark = true
                        }
                        self.presentationMode.wrappedValue.dismiss()
                    }
                } else {
                    alertMessage = message ?? "Failed to update username."
                    showingAlert = true
                }
            }
        }
    }
}

#Preview {
    ProfileSettingsView()
}
