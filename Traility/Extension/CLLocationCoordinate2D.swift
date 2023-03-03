//
//  CLLocationCoordinate2D.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/22/23.
//

import MapKit

extension CLLocationCoordinate2D: Identifiable {
    public var id: String {
        "\(latitude)-\(longitude)"
    }
}
