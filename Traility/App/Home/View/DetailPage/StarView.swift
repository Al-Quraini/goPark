//
//  StarView.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/31/23.
//

import SwiftUI

struct StarsView: View {
    var rating: CGFloat
    var maxRating: Int = 5
    var spacing : CGFloat = 5
    
    var body: some View {
        let stars = HStack(spacing: spacing) {
            ForEach(0..<maxRating, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        
        stars.overlay(
            GeometryReader { g in
                let width = rating / CGFloat(maxRating) * g.size.width + 1
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: width)
                        .foregroundColor(.yellow)
                }
            }
                .mask(stars)
        )
        .foregroundColor(.gray)
    }
}

struct StarsView_Previews: PreviewProvider {
    static var previews: some View {
        StarsView(rating: 4.5)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
