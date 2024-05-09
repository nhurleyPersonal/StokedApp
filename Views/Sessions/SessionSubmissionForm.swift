//
//  SessionSubmissionForm.swift
//  Stoked
//
//  Created by Noah Hurley on 5/8/24.
//

import SwiftUI

struct SessionSubmissionForm: View {
    @State private var sessionTitle = ""
    @State private var speakerName = ""
    @State private var sessionDescription = ""
    @State private var sessionDate = Date()
    @State private var selectedTab = 0
    let inputs = ["30 minutes", "1 hour", "1.5 hours", "2 hours", "2.5 hours", "3+ hours"]
    let textboxColor = "373737"

    var body: some View {
        ZStack {
            Color(hex: "212121")
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                Text("Session Log")
                    .foregroundColor(.white)
                    .font(.system(size: 32))
                DatePicker("Session Date", selection: $sessionDate, displayedComponents: [.date, .hourAndMinute])
                    .labelsHidden()
                    .foregroundColor(.white)
                    .colorScheme(.dark)
                    .padding(.top, -10)

                Rectangle()
                    .fill(Color.clear)
                    .stroke(Color.gray, lineWidth: 1)
                    .frame(width: 200, height: 50)
                    .overlay(
                        TabView(selection: $selectedTab) {
                            ForEach(0 ..< inputs.count) { index in
                                Text(inputs[index])
                                    .foregroundColor(.white)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never)) // <--- here
                        .frame(width: 200, height: 50)
                    )
                    .padding(.bottom, 20)

                HStack {
                    Text("Spot:")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .padding(.trailing, 10)

                    TextField("", text: $sessionTitle)
                        .padding()
                        .background(Color(hex: textboxColor))
                        .border(Color.white, width: 0.5)
                        .foregroundColor(.white)
                        
                }
                .padding(.bottom, 15)
                Text("Describe your session in three words")
                    .foregroundColor(.white)
                    .font(.system(size: 16))

                HStack{
                    TextField("One", text: $sessionTitle)
                        .padding()
                        .background(Color(hex: textboxColor))
                        .border(Color.white, width: 0.5)
                        .foregroundColor(.white)
                    TextField("Two", text: $sessionTitle)
                        .padding()
                        .background(Color(hex: textboxColor))
                        .border(Color.white, width: 0.5)
                        .foregroundColor(.white)
                    TextField("Three", text: $sessionTitle)
                        .padding()
                        .background(Color(hex: textboxColor))
                        .border(Color.white, width: 0.5)
                        .foregroundColor(.white)
                }

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    SessionSubmissionForm()
}
