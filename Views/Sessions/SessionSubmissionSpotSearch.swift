import SwiftUI

struct SessionSubmissionSpotSearch: View {
    @State private var searchText = ""
    @State private var isTextFieldActive = false
    var allSpots: [Spot] // This should be filled with your actual data
    @Binding var selectedSpot: Spot?

    let textboxColor = "373737"

    var filteredSpots: [Spot] {
        if searchText.isEmpty {
            return []
        } else {
            return allSpots.filter { spot in
                spot.name.lowercased().contains(searchText.lowercased())
            }.prefix(5).map { $0 }
        }
    }

    var textFieldText: Binding<String> {
        Binding<String>(
            get: { self.selectedSpot?.name ?? self.searchText },
            set: {
                if $0 != self.searchText {
                    self.selectedSpot = nil
                }
                self.searchText = $0
                if $0.isEmpty {
                    self.isTextFieldActive = true
                }
            }
        )
    }

    var body: some View {
        VStack {
            TextField("Search", text: textFieldText, onEditingChanged: { isEditing in
                isTextFieldActive = isEditing
            })
            .padding()
            .background(Color(hex: textboxColor))
            .border(Color.white, width: 0.5)
            .foregroundColor(.white)

            if isTextFieldActive && selectedSpot == nil {
                ForEach(filteredSpots, id: \.self) { spot in
                    Rectangle()
                        .stroke(Color.gray, lineWidth: 1)
                        .background(Color(hex: "3A3A3A"))
                        .onTapGesture {
                            searchText = spot.name
                            selectedSpot = spot
                            isTextFieldActive = false
                        }
                        .overlay(
                            Text(spot.name)
                                .foregroundColor(.white)
                        )
                        .padding(.vertical, -6)
                        .frame(height: 30)
                }
            }
        }
    }
}
