//
//  DetailImageView.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/22/23.
//

import SwiftUI

struct DetailImageView: View {
    @Binding var clicked: Bool
    @Binding var imageSize : CGSize
    @EnvironmentObject var place : ParkViewModel
    var perform : () -> CGFloat
    var body: some View {
        
        SizeReader(size: $imageSize) {
        Color.clear.background{
            RemoteImageLoader(imageUrl: place.image, aspectRatio: .fill)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        clicked.toggle()
                    }
                }
            }
        }
        .aspectRatio(1.2, contentMode: .fit)
        .clipped()
        .ignoresSafeArea()
    }
}

struct DetailImageView_Previews: PreviewProvider {
    static var previews: some View {
        DetailImageView(clicked: .constant(true), imageSize: .constant(.zero), perform: { return 0} )
    }
}
