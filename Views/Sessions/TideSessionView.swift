//
//  TideSessionView.swift
//  Stoked
//
//  Created by Noah Hurley on 5/7/24.
//

import SwiftUI

struct TideSessionView: View {
    var body: some View {
        HStack {
            Text("1.5'")
            VStack{
                
                Image(systemName: "arrow.up")
                    .rotationEffect(.degrees(60))
                    .foregroundColor(.white)
                Text("")
            }
            
            VStack{
                Text("4.2'")
                Text("")
                Text("")
            }
            
        }
        .font(.system(size:20))
        .foregroundColor(.white)
        
    }
}

#Preview {
    TideSessionView()
}
