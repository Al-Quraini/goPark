//
//  CalendarManager.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 3/2/23.
//

import Foundation

struct CalendarManager {
    
    func getWelcomeMessage() -> String {
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 0..<12 : return "Good morning"
        case 12..<19 : return "Good afternoon"
        case 19..<22 : return "Good evening"
        default: return "Good morning"
        }
    }
}
