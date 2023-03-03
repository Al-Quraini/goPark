//
//  ViewExtension.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/15/23.
//

import Foundation
import SwiftUI

extension View {
    func textFieldModifier(horizontalPadding : Double, action : @escaping () -> ()) -> some View {
        modifier(TextFieldModifier(action: action, horizontalPadding: horizontalPadding))
    }
    
    func searchTextFieldModifier(horizontalPadding : Double, action : @escaping () -> ()) -> some View {
        modifier(SearchTextFieldModifier(action: action, horizontalPadding: horizontalPadding))
    }
    
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
