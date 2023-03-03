//
//  ActivityObject+CoreDataProperties.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/27/23.
//
//

import Foundation
import CoreData


extension ActivityObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActivityObject> {
        return NSFetchRequest<ActivityObject>(entityName: "ActivityObject")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var entityId: ParkManagedObject?
    
    
    public var wrappedName : String {
        name ?? ""
    }

    public var wrappedid : UUID {
        id ?? UUID()
    }


}

extension ActivityObject : Identifiable {

}
