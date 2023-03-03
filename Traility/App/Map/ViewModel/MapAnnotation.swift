//
//  MapAnnotation.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/9/23.
//

import MapKit

class ParkAnnotation: NSObject, MKAnnotation, Identifiable {
    let identifier = "locations"
    
    let id : UUID
    let title: String?
    let locationName: String?
    let discipline: String?
    let name : String
    let location : String
    let imageUrl : String?
    let coordinate: CLLocationCoordinate2D
    
    init(
        id : UUID,
        title: String?,
        locationName: String?,
        name : String,
        location : String,
        imageUrl : String?,
        discipline: String?,
        coordinate: CLLocationCoordinate2D
    ) {
        self.id = id
        self.title = title
        
        self.locationName = locationName
        self.discipline = discipline
        self.name = name
        self.location = location
        self.imageUrl = imageUrl
        self.coordinate = coordinate
        
        super.init()
    }
    
//    var subtitle: String? {
//        return locationName
//    }
    
}
