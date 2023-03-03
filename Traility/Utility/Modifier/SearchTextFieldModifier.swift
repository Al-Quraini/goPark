//
//  SearchTextFieldModifier.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/20/23.
//

import Foundation
import SwiftUI

struct SearchTextFieldModifier: ViewModifier {
    var action : () -> ()
    var horizontalPadding : Double = 20
    func body(content: Content) -> some View {
        content
            .frame( minHeight: 35, idealHeight: 40 ,maxHeight: 45, alignment: .center)
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            .background(Color(.lightGray).opacity(0.1))
            .cornerRadius(20)
            .onTapGesture(perform: action)
            .padding(.horizontal,horizontalPadding)
            .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
