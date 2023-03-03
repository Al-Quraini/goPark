//
//  ImageCarousel.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/8/23.
//

import SwiftUI

struct ImageCarousel: View {
    @EnvironmentObject var place : ParkViewModel
    @State private var offset:CGFloat = .zero
    @State private var lastOffset: CGFloat = .zero
    @State private var currentIndex : Int = .zero
    @Binding var clicked : Bool
    var onChanged : (_ value : DragGesture.Value) -> Void
    var onEnded : (_ value : DragGesture.Value) -> Void
    
    var body: some View {
        ZStack(alignment: .top) {
            LazyHStack(spacing : 0){
                ForEach(place.imagesModels, id: \.self) { image in
                    RemoteImageLoader(imageUrl: image.url, aspectRatio: .fit)
                        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight * 0.8)
                        .contentShape(Rectangle())
                }
            }
            .frame(width: getDimensions().canvasWidth)
            .offset(x: getOffset())
            .gesture(
                DragGesture()
                    .onChanged({ val in
                        self.offset = lastOffset + val.translation.width
                    })
                    .onEnded({ val in
                        endDragging()
                    })
            )
            .onAppear{
                self.offset = getDimensions().xOffset
                self.lastOffset = offset
            }
            
            VStack {
                Spacer()
                HStack(spacing : 8) {
                    ForEach(0..<place.imagesModels.count, id: \.self) { i in
                        Circle().foregroundColor(Color(
                            i == currentIndex ? TrailityColor.primary : .systemGray6
                            )
                        )
                        .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 20 + (DisplaySizeManager.getSafeArea()?.bottom ?? 0))
            }
            
            HStack {
                Button {
                    withAnimation {
                        clicked = false
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 35, height: 35)
                }
                Spacer()
            }
            .padding(.top,( DisplaySizeManager.getSafeArea()?.top ?? 20) + 25)
            .padding()
            .frame(width: UIScreen.screenWidth)
            .contentShape(Rectangle())
        }
    }
    
    func getOffset() -> CGFloat {
        if offset > getDimensions().xOffset {
            return getDimensions().xOffset
        }
        if offset < -getDimensions().xOffset {
            return -getDimensions().xOffset
        }
        return offset
    }
    
    func endDragging() {
        if offset > getDimensions().xOffset {
            offset = getDimensions().xOffset
        }
        if offset < -getDimensions().xOffset {
            offset = -getDimensions().xOffset
        }
        let dragDifference = (offset - lastOffset)/UIScreen.screenWidth
        if dragDifference < 0 && dragDifference < -0.3 {
            lastOffset -= UIScreen.screenWidth
        }
        else if dragDifference > 0 && dragDifference > 0.3 {
            lastOffset += UIScreen.screenWidth
        }
        let index = abs(Int((lastOffset - getDimensions().xOffset)/UIScreen.screenWidth))
        withAnimation {
            currentIndex = index
            offset = lastOffset
        }
    }
    
    func getDimensions() -> (canvasWidth :CGFloat, xOffset: CGFloat){
        let totalCanvasWidth = CGFloat(place.imagesModels.count) * UIScreen.screenWidth
        let xOffsetToShift = (totalCanvasWidth - UIScreen.screenWidth)/2
        
        return (totalCanvasWidth, xOffsetToShift)
    }
}

struct ImageCarousel_Previews: PreviewProvider {
    static var previews: some View {
        ImageCarousel(clicked : .constant(false), onChanged: {_ in}, onEnded: {_ in})
    }
}
