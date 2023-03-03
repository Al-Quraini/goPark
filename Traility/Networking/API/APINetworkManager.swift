//
//  NetworkManager.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/1/23.
//

import Foundation

struct APINetworkManager {
    func performRequest<T : Codable>(_ model : T.Type, from url: String, completion: @escaping (Result<T, APINetworkError>) -> Void)   {
        guard let url = URL(string: url)
        else {
            completion(.failure(.badURL))
                       return
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data , response, error in
            if let error = error {
                completion(.failure(.other(error)))
                       return
                   }
        if let safeData = data {
                do {
                    let response = try JSONDecoder().decode(model, from: safeData)
                    completion(.success(response))
                } catch let error {
                    completion(.failure(.other(error)))
                }
            }
        }
        task.resume()
    }
    
    func performAsyncRrequest<T>(_ model : T.Type, from url: String) async throws -> T  where T : Codable {
        guard let url = URL(string: url) else {
            throw APINetworkError.badURL
        }
        let session = URLSession(configuration: .default)
        do {
            let (data, response) = try await session.data(from: url)
            if let response = response as? HTTPURLResponse{
                if response.statusCode == 200 {
                    let decodedData = try JSONDecoder().decode(model, from: data)
                    return decodedData
                }
                throw APINetworkError.badResponse(response.statusCode)
            }
            throw APINetworkError.badResponse(500)
        } catch let e {
            throw APINetworkError.other(e)
        }
    }
}
