//
//  NetworkUrls.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/1/23.
//

import Foundation

struct APINetworkURLs {
    // urls
    static let baseNPSUrl = "https://developer.nps.gov/api/v1"
    static let api_key = "THbbIrnka5JyjSvs6iqknrD5Lb2ED7S69Mo98ChQ"
}

enum APIEndpoint : String {
    case parks
    case activities
    case activiesParks = "activities/parks"
}

struct URLManager {
    func getUrl(endPoint : APIEndpoint, params : [String : String]?) -> String {
        let parameters = {
            if let params = params {
                let parameters = params.keys.map { key in
                    let val : String = params[key] ?? ""
                    let splittedVal : String = val.split(separator: " ").enumerated().map { i , string in
                        return i == 0 ? string : "+\(string)"
                    }.joined()
                    return "\(key)=\(splittedVal)&"
                }
                return parameters.joined()
            }
            return ""
        }()
        return "\(APINetworkURLs.baseNPSUrl)/\(endPoint.rawValue)?\(parameters)api_key=\(APINetworkURLs.api_key)"
    }
}
