//
//  Extensions.swift
//  Swipe
//
//  Created by Nafeez Ahmed on 13/11/24.
//

import SwiftUI

extension Font {

    static func customTitleFont(size: CGFloat) -> Font {
        return Font.custom("NeuePlak-ExtraBlack", size: size)
    }
    
    static func customFont(size: CGFloat) -> Font {
        return Font.custom("NeuePlak-Regular", size: size)
    }
}

extension Color {
    static var Purple: Color { return Color("Purple") }
    static var Red: Color { return Color("Red") }
    static var Green: Color { return Color("Green") }
    static var Yellow: Color { return Color("Yellow") }
    static var DarkGreen: Color { return Color("Dark-G") }
    static var customBlack: Color { return Color("Black") }
}
