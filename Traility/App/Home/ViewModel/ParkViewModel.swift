//
//  ParkViewModel.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/24/23.
//

import Foundation
import MapKit

class ParkViewModel : Identifiable, ObservableObject {
    init(data : ParkData) {
        self.id =  data.id.toUUID()
        self.name = data.fullName ?? "N/A"
        self.city = data.addresses?.first?.city ?? "N/A"
        self.state = data.addresses?.first?.stateCode ?? "N/A"
        self.description = data.description ?? "N/A"
        self.parkCode = data.parkCode ?? "N/A"
        self.latitude = Double(data.latitude ?? "") ?? 0.0
        self.longitude = Double(data.longitude ?? "") ?? 0.0
        self.directionsInformation = data.directionsInfo ?? "N/A"
        self.image = data.images?.first?.url
        self.url = data.url
        self.designation = data.designation ?? ""
        bindActivities(data.activities)
        bindImagesData(data.images)
    }
    
    init(data : ParkManagedObject){
        self.id =  data.id ?? UUID()
        self.name = data.name.unkownWhenNil
        self.city = data.city.unkownWhenNil
        self.state = data.state.unkownWhenNil
        self.description = data.parkDiscreption.unkownWhenNil
        self.parkCode = data.parkCode.unkownWhenNil
        self.latitude = data.latitude
        self.longitude = data.longitude
        self.directionsInformation = data.directionsInformation.unkownWhenNil
        self.image = data.wrappedImageUrl
        self.url = data.url
        self.designation = data.wrappedDesignation
        self.isVisited = data.isVisited
        convertManagedImages(data.imagesData)
        convertManagedActivities(data.activities)
        

    }
    
    let id: UUID
    let name : String
    let city : String
    let state : String
    let parkCode : String
    let description : String
    let latitude : Double
    let longitude : Double
    let directionsInformation : String
    let designation : String
    let url  : String?
    let image : String?
    var activities : [ActivityVM] = []
    var imagesModels : [ImageDataVM] = []
    var imagesData : [Data]? = nil
    var mapAnnotation : ParkAnnotation? = nil
    var isVisited : Bool = false
    

    
    func bindImagesData(_ data : [PlaceImageData]?) {
        guard let data = data else {return }
        let images : [ImageDataVM] = data.map { image in
            let imageVM : ImageDataVM =
            ImageDataVM(
                credit: image.credit ?? "N/A",
                title: image.title ?? "N/A",
                altText: image.altText ?? "",
                caption: image.caption ?? "",
                url: image.url
            )
            return imageVM
        }
        self.imagesModels = images
    }
    
    func bindActivities(_ data : [Activity]?) {
        guard let dataActivities = data else {return }
        let activities =  dataActivities.map { activity in
            let id = activity.id.toUUID()
            return ActivityVM(id: id, name: activity.name)
        }
        self.activities = activities
    }
    
    func bindAnnotation() {
        let location = "\(city), \(state)"
        let annotation =
        ParkAnnotation(
            id : self.id,
            title: nil,
            locationName: nil,
            name: self.name,
            location: location,
            imageUrl: image,
            discipline: nil,
            coordinate: CLLocationCoordinate2DMake(self.latitude, self.longitude)
        )
        self.mapAnnotation = annotation
    }
    
    func convertManagedImages(_ images :  Set<ImageDataObject>?) {
        guard let images = images else { return }
        let imagesArray = Array(images)
        let imagesData = imagesArray.map { image in
            return ImageDataVM(id: image.wrappedId, credit: "", title: image.wrappedTitle, altText: "", caption: image.wrappedCaption, url: image.wrappedUrl)
        }
        self.imagesModels = imagesData
    }
    
    func convertManagedActivities(_ activities :  Set<ActivityObject>?) {
        guard let activities = activities else { return }
        let activitiesArray = Array(activities)
        let activitiesData = activitiesArray.map { activity in
            return ActivityVM(id: activity.wrappedid, name: activity.wrappedName)
        }
        
        self.activities = activitiesData
        
    }
    
    
    struct ImageDataVM : Hashable, Identifiable {
        var id: UUID = UUID()
        let credit: String
        let title: String
        let altText: String
        let caption: String
        let url: String?
        let data : Data? = nil
    }
}

struct ActivityVM : Identifiable, Hashable {
    static func == (lhs: ActivityVM, rhs: ActivityVM) -> Bool {
        lhs.id == rhs.id
    }
    
    let id : UUID
    let name : String
}


extension ParkViewModel: Hashable, Equatable {
    static func == (lhs: ParkViewModel, rhs: ParkViewModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

