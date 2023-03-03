//
//  ImageService.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/24/23.
//

import Foundation

struct ImageService {
    func getImageData(_ urlString : String?, completion : @escaping (Data?, Error?) -> Void) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            completion(nil, APINetworkError.badURL)
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            if let data = data {
                completion(data, nil)
                return
            }
            completion(nil, nil)
        }
        dataTask.resume()
    }
    
    func getAsyncImage(from urlString : String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw APINetworkError.badURL
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse else {
                throw APINetworkError.badResponse(500)
            }
            if response.statusCode == 200 {
                return data
            }
            throw APINetworkError.badResponse(response.statusCode)
        } catch {
            throw error
        }
    }
}
