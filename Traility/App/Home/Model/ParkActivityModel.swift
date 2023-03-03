//
//  ParkActivityModel.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/27/23.
//

import Foundation

struct ParkActivityModel : Codable {
    let total : String?
    let data : [ActivityForParkData]
}

struct ActivityForParkData : Codable {
    let id : String?
    let name : String?
    let parks : [ParksForActivity]?
}

struct ParksForActivity : Codable {
    let states : String?
    let parkCode : String?
    let fullName : String?
    
}
