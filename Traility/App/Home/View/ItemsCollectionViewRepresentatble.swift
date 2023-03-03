//
//  ItemsCollectionViewRepresentatble.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/18/23.
//

import Foundation
import SwiftUI

struct ItemsCollectionView: UIViewRepresentable {
    let viewModel : HomeViewModel

    func makeUIView(context: Context) -> UIView {
        HomeItemsCollectionView(viewModel:  viewModel)
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
