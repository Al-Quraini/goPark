//
//  MapServices.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/14/23.
//

import Foundation
import MapKit
import UIKit

struct MapServices {
    fileprivate let mapRouter : MapRouter = MapRouter()
    
    func centerMapOnLocation(_ coordinate: CLLocationCoordinate2D, mapView : MKMapView) {
        let regionRadius: CLLocationDistance = 100000
        let coordinateRegion = MKCoordinateRegion(center: coordinate,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func getCenterLocation(for mapView : MKMapView) -> CLLocation? {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }

    func reverseGeoCoder(center : CLLocation, completion : @escaping (CLPlacemark?) -> () ) {
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(center) { placeMark, error in
            if let _ = error {
                completion(nil)
                return
            }
            
            guard let placeMark = placeMark?.first else {
                completion(nil)
                return
            }
            if placeMark.country != "United States" {
                completion(nil)
                return
            }
            completion(placeMark)
        }
    }
    
    func getDirections(mapApp : MapApp, lat : CGFloat, long: CGFloat, name : String) {
        mapRouter.getMapDirections(mapApp: mapApp, lat: lat, long: long, name: name)
    }
}

fileprivate struct MapRouter {
    func getMapDirections(mapApp : MapApp, lat : CGFloat, long: CGFloat, name : String) {
        switch mapApp {
        case .appleMaps :
//            if let mapsURL = URL(string: "maps://q?\(lat),\(long)") {
//                UIApplication.shared.open(mapsURL)
//            }
            openMap()
            break
        case .googleMaps :
            if
                let url = URL(string: "comgooglemaps://?saddr=&daddr=\(lat),\(long)&directionsmode=driving")
            {
                //code here
                if  UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                else{
                    if let urlBrowser = URL(string: "https://www.google.co.in/maps/dir/??saddr=&daddr=\(lat),\(lat)&directionsmode=driving") {
                        UIApplication.shared.open(urlBrowser, options: [:], completionHandler: nil)
                    }
                }
            }
            break
        }
        func openMap() {
            let latitude: CLLocationDegrees = Double(lat)
            let longitude: CLLocationDegrees = Double(long)
            let regionDistance:CLLocationDistance = 10000
            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
            let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ]
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = name
            mapItem.openInMaps(launchOptions: options)
        }
    }
}
