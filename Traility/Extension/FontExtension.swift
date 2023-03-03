//
//  FontExtension.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/5/23.
//

import Foundation
import SwiftUI

extension Font  {
    public static func poppins(size fontSize : CGFloat = 12, weight fontWeight : PoppinsFontWeight = .regular) -> Font{
        return Font.custom(fontWeight.rawValue, size: fontSize)
    }
}

extension UIFont {
    public static func poppins(size fontSize : CGFloat = 12, weight fontWeight : PoppinsFontWeight = .regular) -> UIFont{
        
        return UIFont(name: fontWeight.rawValue, size: fontSize) ?? .systemFont(ofSize: 12)
    }
}

public enum PoppinsFontWeight : String {
    case black = "Poppins-Black"
    case blackItalic = "Poppins-BlackItalic"
    case bold = "Poppins-Bold"
    case boldItalic = "Poppins-BoldItalic"
    case extraBold = "Poppins-ExtraBold"
    case extraBoldItalic = "Poppins-ExtraBoldItalic"
    case extraLight = "Poppins-ExtraLight"
    case extraLightItalic = "Poppins-ExtraLightItalic"
    case italic = "Poppins-Italic"
    case light = "Poppins-Light"
    case lightItalic = "Poppins-LightItalic"
    case medium = "Poppins-Medium"
    case mediumItalic = "Poppins-MediumItalic"
    case regular = "Poppins-Regular"
    case semiBold = "Poppins-SemiBold"
    case semiBoldItalic = "Poppins-SemiBoldItalic"
    case thin = "Poppins-Thin"
    case thinItalic = "Poppins-ThinItalic"
}
