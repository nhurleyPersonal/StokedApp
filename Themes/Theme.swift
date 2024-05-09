//
//  Theme.swift
//  Stoked
//
//  Created by Noah Hurley on 4/10/24.
//

import SwiftUI

struct Theme {
    let id: Int
    let backgroundColor: Color
    let bodyFont: Font
    let titleFont: Font
    let darkDark: Color
    let darkMed: Color
    let darkLight: Color
    let accentBlue: Color
    let accentRed: Color
    let textColor: Color
    let topPicksBlue: Color
}

struct ThemeKey: EnvironmentKey {
    static let defaultValue: Theme = {
        guard let customBodyFont = UIFont(name: "Raleway", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }

        guard let customTitleFont = UIFont(name: "Outfit", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
    
        return Theme(id: 1, backgroundColor: .white, bodyFont: Font(customBodyFont), titleFont: Font(customTitleFont),
                     darkDark: Color(UIColor(red: 0x0F / 255, green: 0x13 / 255, blue: 0x18 / 255, alpha: 1)),
                     darkMed: Color(UIColor(red: 0x22 / 255, green: 0x2B / 255, blue: 0x36 / 255, alpha: 1)),
                     darkLight: Color(UIColor(red: 0x3F / 255, green: 0x4D / 255, blue: 0x5C / 255, alpha: 1)),
                     accentBlue: Color(UIColor(red: 0x23 / 255, green: 0xD9 / 255, blue: 0xF2 / 255, alpha: 1)),
                     accentRed: Color(UIColor(red: 0xCC / 255, green: 0x47 / 255, blue: 0x47 / 255, alpha: 1)),
                     textColor: Color(UIColor(red: 0xE7 / 255, green: 0xE8 / 255, blue: 0xE8 / 255, alpha: 1)),
                     topPicksBlue: Color(UIColor(red: 0x29 / 255, green: 0x2C / 255, blue: 0x43 / 255, alpha: 1)))
    }()
}

extension EnvironmentValues {
    var theme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}
