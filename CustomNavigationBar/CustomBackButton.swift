//
//  CustomBackButton.swift
//  Stoked
//
//  Created by Noah Hurley on 6/26/24.
//

import Foundation
import SwiftUI

struct CustomBackButton: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.left")
                .foregroundColor(.white)
                .imageScale(.large)
                .padding()
        }
    }
}
