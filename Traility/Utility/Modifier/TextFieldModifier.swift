//
//  TextFieldModifierr.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/2/23.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    var action : () -> ()
    var horizontalPadding : Double = 20
    func body(content: Content) -> some View {
        content
            .frame( minHeight: 35, idealHeight: 40 ,maxHeight: 45, alignment: .center)
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .onTapGesture(perform: action)
            .padding(.horizontal,horizontalPadding)
            .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
