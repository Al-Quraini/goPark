//
//  Seens.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/22/23.
//

import SwiftUI

struct Videos: View {
    let data = (1...5).map { "Item \($0)" }

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(data, id: \.self) { item in
                    Image(AssetImageName.appIcon)
                        .resizable()
                        .scaledToFit()
                }
            }
            .padding(.horizontal)
    }
}

struct Seens_Previews: PreviewProvider {
    static var previews: some View {
        Videos()
    }
}
