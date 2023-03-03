//
//  PersistenceController.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/26/23.
//

import CoreData

final class PersistenceController {
    static let shared = PersistenceController()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Traility")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let _ = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveContext(for context : NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let _ = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchObjects<Object : NSManagedObject>(entityId : UUID?, context : NSManagedObjectContext) throws -> [Object] {
        let fetchRequest : NSFetchRequest = Object.fetchRequest()
        
        if let entityId = entityId {
            fetchRequest.fetchLimit = 1
            let predicate : NSPredicate = NSPredicate(format: "%K == %@", "id", entityId as CVarArg)
            fetchRequest.predicate = predicate
        }
        do {
            if let objects : [Object] = try context.fetch(fetchRequest) as? [Object] {
                return objects
            } else {
                throw PersistenError.fetchFailed
            }
        } catch {
                throw error
            }
        }
    
    func deleteObject( object : NSManagedObject.Type,entityId : UUID, context : NSManagedObjectContext) throws  {
        let fetchRequest : NSFetchRequest = object.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        let predicate : NSPredicate = NSPredicate(format: "%K == %@", "id", entityId as CVarArg)
        fetchRequest.predicate = predicate

        do {
            if let items = try context.fetch(fetchRequest) as? [NSManagedObject] {
                for item in items {
                    context.delete(item)
                }
            } else {
                throw PersistenError.fetchFailed
            }
            
        } catch {
                throw error
            }
        }
}

struct CoreDataManager {
    let coreData = PersistenceController.shared
    
    func storePark( model : ParkViewModel, markVisited : Bool = false){
        if let entity = NSEntityDescription.entity(forEntityName: ParkManagedObject.entityName, in: coreData.persistentContainer.viewContext){
            let park = ParkManagedObject(entity: entity, insertInto: coreData.persistentContainer.viewContext)
            park.id = model.id
            park.name = model.name
            park.latitude = model.latitude
            park.longitude = model.longitude
            park.isVisited = markVisited
            park.city = model.city
            park.state = model.state
            park.designation = model.designation
            park.directionsInformation = model.directionsInformation
            park.image = model.image
            park.parkCode = model.parkCode
            park.parkDiscreption = model.description
            park.url = model.url
            
            for image in model.imagesModels {
                storeImage(imageData: image, object: park)
            }
            
            for activity in model.activities {
                storeActivity(activity: activity, object: park)
            }
            
            
            coreData.saveContext()
        }
    }
    
    private func storeImage(imageData : ParkViewModel.ImageDataVM, object : ParkManagedObject){
        if let entity = NSEntityDescription.entity(forEntityName: ImageDataObject.entityName, in: coreData.persistentContainer.viewContext){
            let image = ImageDataObject(entity: entity, insertInto: coreData.persistentContainer.viewContext)
            image.url = imageData.url
            image.id = imageData.id
            image.title = imageData.title
            image.caption = imageData.caption
            image.entityId = object
            
        }
    }
    
    private func storeActivity(activity : ActivityVM, object : ParkManagedObject){
        if let entity = NSEntityDescription.entity(forEntityName: ActivityObject.entityName, in: coreData.persistentContainer.viewContext){
            let activityObject = ActivityObject(entity: entity, insertInto: coreData.persistentContainer.viewContext)
            activityObject.name = activity.name
            activityObject.id = activity.id
            activityObject.entityId = object
            
        }
    }
    
    
    func getPark(id : UUID) -> ParkManagedObject? {
        do {
            let parks : [ParkManagedObject] = try coreData.fetchObjects(entityId: id, context: coreData.persistentContainer.viewContext)
                return parks.first
        } catch {
            return nil
        }
    }
    
    func getAllParks() -> [ParkManagedObject]? {
        do {
            let parks : [ParkManagedObject] = try coreData.fetchObjects(entityId: nil, context: coreData.persistentContainer.viewContext)
                return parks
        } catch {
            return nil
        }
    }
    
    func deletePark(id : UUID) -> Bool {
        do {
           try coreData.deleteObject(object: ParkManagedObject.self, entityId: id, context: coreData.persistentContainer.viewContext)
            return true
        } catch {
            return false
        }
    }
    
    func updateParkVisitStatus(id : UUID ,isVisited : Bool) -> Bool {
        do {
            let parks : [ParkManagedObject] = try coreData.fetchObjects(entityId: id, context: coreData.persistentContainer.viewContext)
            
            if let park = parks.first {
                park.isVisited = isVisited
                coreData.saveContext()
                return true
            }
            return false
        } catch {
            return false
        }
    }
    

}

enum PersistenError : Error {
    case fetchFailed
}

