//
//  CodableBundleExtension.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/13/23.
//

import Foundation

extension Bundle {
    func decode<T: Codable>(_ file : String) throws -> T {
        // 1. Locate the json file
        guard let url = self.url(forResource: file, withExtension: "json")
        else {
            throw BundleError.noPath
        }
        
        // 2. Create a property for the data
        guard let data = try? Data(contentsOf: url) else {
            throw BundleError.failedLoading
        }
        
        //3. Create a decoder
        let decoder = JSONDecoder()
        
        //4. Create a property for the decoded data
        guard let decodedData = try? decoder.decode(T.self, from: data)
        else {
            throw BundleError.failedDecoding

        }
        
        //5. Return the ready-to-use
        return decodedData
    }
}

enum BundleError : Error {
    case noPath
    case failedLoading
    case failedDecoding
}
