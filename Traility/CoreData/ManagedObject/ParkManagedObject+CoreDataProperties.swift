//
//  ParkManagedObject+CoreDataProperties.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/27/23.
//
//

import Foundation
import CoreData


extension ParkManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ParkManagedObject> {
        return NSFetchRequest<ParkManagedObject>(entityName: "ParkManagedObject")
    }

    @NSManaged public var city: String?
    @NSManaged public var designation: String?
    @NSManaged public var directionsInformation: String?
    @NSManaged public var id: UUID?
    @NSManaged public var image: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var parkCode: String?
    @NSManaged public var parkDiscreption: String?
    @NSManaged public var state: String?
    @NSManaged public var url: String?
    @NSManaged public var isVisited: Bool
    @NSManaged public var imagesData: Set<ImageDataObject>?
    @NSManaged public var activities: Set<ActivityObject>?
    
    
    public var unwrappedId : UUID {
        id ?? UUID()
    }

    public var wrappedName : String {
        name.unkownWhenNil
    }

    public var wrappedCity : String {
        city.unkownWhenNil
    }

    public var wrappedState : String {
        state.unkownWhenNil
    }

    public var wrappedDesignation : String {
        designation.unkownWhenNil
    }

    public var wrappedDirectionsInformation: String {
        directionsInformation.unkownWhenNil
    }

    public var wrappedImageUrl: String {
        image.unkownWhenNil
    }

    public var wrappedParkCode: String {
        parkCode.unkownWhenNil
    }

    public var wrappedDescription: String {
        parkDiscreption.unkownWhenNil
    }

    public var wrappedUrl: String {
        url.unkownWhenNil
    }

    public var imagesArray : [ImageDataObject] {
        let set = imagesData as? Set<ImageDataObject> ?? []
        
        return Array(set)
    }

    public var activitiesArray : [ActivityObject] {
        let set = activities as? Set<ActivityObject> ?? []
        
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }

}

// MARK: Generated accessors for imagesData
extension ParkManagedObject {

    @objc(addImagesDataObject:)
    @NSManaged public func addToImagesData(_ value: ImageDataObject)

    @objc(removeImagesDataObject:)
    @NSManaged public func removeFromImagesData(_ value: ImageDataObject)

    @objc(addImagesData:)
    @NSManaged public func addToImagesData(_ values:  Set<ImageDataObject>)

    @objc(removeImagesData:)
    @NSManaged public func removeFromImagesData(_ values:  Set<ImageDataObject>)

}

// MARK: Generated accessors for activities
extension ParkManagedObject {

    @objc(addActivitiesObject:)
    @NSManaged public func addToActivities(_ value: ActivityObject)

    @objc(removeActivitiesObject:)
    @NSManaged public func removeFromActivities(_ value: ActivityObject)

    @objc(addActivities:)
    @NSManaged public func addToActivities(_ values: Set<ActivityObject>)

    @objc(removeActivities:)
    @NSManaged public func removeFromActivities(_ values: Set<ActivityObject>)

}

extension ParkManagedObject : Identifiable {

}
