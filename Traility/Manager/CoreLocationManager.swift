//
//  CoreLocationManager.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/14/23.
//

import Foundation
import CoreLocation

final class CoreLocationManager : NSObject {
//    static let _default = CoreLocationManager()
    @Published private(set) var currentState : String?
    let locationManager : CLLocationManager = CLLocationManager()
    var isUserLocationAuthorized : Bool {
        locationManager.authorizationStatus == .authorizedWhenInUse
            || locationManager.authorizationStatus == .authorizedAlways
    }
 
    //MARK: - Core Location
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                
                self.setupLocationManager()
                self.checkLocationAuthorization()
                
            } else {
                
            }
        }
    }
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            getPlaceMarkData()
            break
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    
    func getPlaceMarkData() {
        if let location = locationManager.location {
            MapServices().reverseGeoCoder(center: location) { placeMark in
                self.currentState = placeMark?.administrativeArea
            }
        }
    }
}
extension CoreLocationManager : CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}


