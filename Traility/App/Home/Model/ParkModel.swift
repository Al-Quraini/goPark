//
//  Park.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/24/23.
//

import Foundation

struct ParkModel : Codable {
    let total : String
    let data : [ParkData]
}

struct ParkData : Codable {
    let id : String
    let url : String?
    let fullName: String?
    let parkCode : String?
    let description : String?
    let latitude : String?
    let longitude : String?
    let state : String?
    let addresses : [ParkAddress]?
    let images : [PlaceImageData]?
    let activities : [Activity]?
    let weatherInfo : String?
    let directionsInfo : String?
    let designation : String?
    
}

struct ParkAddress : Codable {
    let line1 : String?
    let city : String?
    let stateCode : String?
    let postalCode : String?
}

struct PlaceImageData : Codable {
    let credit: String?
    let title: String?
    let altText: String?
    let caption: String?
    let url: String?
}

struct Activity : Codable {
    let id : String
    let name : String
}

struct Contacts : Codable {
    let phoneNumbers : PhoneNumber?
    let emailAddresses : EmailAddress?
}

struct PhoneNumber : Codable {
    let phoneNumber : String?
    let type : String?
}

struct EmailAddress : Codable {
    let emailAddress : String
}

