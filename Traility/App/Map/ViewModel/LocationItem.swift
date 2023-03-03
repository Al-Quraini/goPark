//
//  LocationItem.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/22/23.
//

import Foundation
import CoreLocation

struct LocationItem: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
