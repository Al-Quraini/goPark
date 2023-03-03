//
//  ActivityModel.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/23/23.
//

import Foundation

struct ActivityModel : Codable {
    let total : String
    let limit : String
    let start : String
    let data : [ActivityData]
}

struct ActivityData : Codable {
    let id : String
    let name : String
}
