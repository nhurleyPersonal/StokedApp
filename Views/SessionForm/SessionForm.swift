//
//  SessionForm.swift
//  Stoked
//
//  Created by Noah Hurley on 4/10/24.
//

import SwiftUI

struct SessionForm: View {
    @Environment(\.theme) var theme
    @State private var text = ""
    
    var body: some View {
        HStack{
            Text("Log a Session")
                .padding()
                .font(.title)
            Spacer()
        }
        VStack {
            DisclosureGroup("Log Session") {
                
            }
            .padding()
            Spacer()
        }
    }
}

#Preview {
    SessionForm()
}
