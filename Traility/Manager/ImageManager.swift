//
//  ImageViewModelManager.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/7/23.
//

import Foundation
import UIKit

struct ImageManager  {
    private let imageCache = ImageCache.getImageCache()
    func getImageData(url : String?) async -> ImageState {
        guard let url = url else { return .noImage }
        if let image = imageCache.get(forKey: url) {
            return .loaded(image)
        }
        do {
            let data = try await ImageService().getAsyncImage(from: url)
            if let image = UIImage(data: data) {
                imageCache.set(forKey: url, image: image)
                return .loaded(image)
            }
            return .noImage
        } catch {
            return .noImage
        }
    }

    func getImageCompletion(url : String?, completion : @escaping (ImageState) -> ()){
        guard let url = url else { completion(.noImage); return }
        if let image = imageCache.get(forKey: url) {
            completion(.loaded(image))
            return
        }
        ImageService().getImageData(url) { data, error in
            if let _ = error {
                completion(.noImage)
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                completion(.noImage)
                return
            }
            imageCache.set(forKey: url, image: image)
            completion(.loaded(image))
            return
        }
    }
    
    func loadImages(url: String?, completion : @escaping (Result<Data, Error>) -> () ) {
        guard let url = url else { completion(.failure(APINetworkError.badURL)); return }
        ImageService().getImageData(url) { data, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(APINetworkError.badResponse(100)))
                return
            }
            completion(.success(data))
        }
    }
        
    enum ImageState {
        case loading
        case loaded(UIImage)
        case noImage
    }
}
