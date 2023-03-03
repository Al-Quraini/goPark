//
//  RemoteImageManager.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/7/23.
//

import SwiftUI

struct RemoteImageLoader: View {
    @State private var imageState : ImageManager.ImageState = .loading
    let imageUrl : String?
    let aspectRatio : ContentMode
    
    var body: some View {
        ZStack {
            switch imageState {
            case .loading:
                Color.clear
                
            case .loaded(let image):
               if let image = Image(uiImage: image) {
                   image.resizable().aspectRatio(contentMode: aspectRatio)
                } else {
                    placeHolderImage
                }
           
            default :
                placeHolderImage
            }
        }
        .onAppear {
            Task {
                self.imageState = await ImageManager().getImageData(url: self.imageUrl)
            }
        }
    }
    
    private var placeHolderImage : some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .foregroundColor(.gray)
            .padding(30)
    }
    
}

struct RemoteImageManager_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImageLoader(imageUrl: nil, aspectRatio: .fit)
    }
}
