//
//  ImageDataObject+CoreDataProperties.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/27/23.
//
//

import Foundation
import CoreData


extension ImageDataObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageDataObject> {
        return NSFetchRequest<ImageDataObject>(entityName: "ImageDataObject")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var caption: String?
    @NSManaged public var url: String?
    @NSManaged public var data: Date?
    @NSManaged public var entityId: ParkManagedObject?
    
    public var wrappedId : UUID {
        id ?? UUID()
    }
    
    public var wrappedTitle : String {
        title ?? ""
    }
    
    public var wrappedCaption : String {
        caption ?? ""
    }
    
    public var wrappedUrl : String {
        url ?? ""
    }

}

extension ImageDataObject : Identifiable {

}
