//
//  ParksForActivityViewModel.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/27/23.
//

import Foundation

struct ParksForActivityViewModel : Hashable {
    init(decodable : ParksForActivity, activityName : String?, id : String?) {
        self.id = id.toUUID()
        self.activityName = activityName ?? ""
        self.parkName = decodable.fullName ?? ""
        self.parkCode = decodable.parkCode ?? ""
        self.states = decodable.states ?? ""
    }
    let id : UUID
    let activityName : String
    let parkName : String
    let parkCode : String
    let states : String
    
}
