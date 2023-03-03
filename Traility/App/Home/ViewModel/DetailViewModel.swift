//
//  DetailViewModel.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/25/23.
//

import Foundation

class DetailViewModel : ObservableObject {
    private let coreData : PersistenceController = PersistenceController.shared
    @Published private(set) var isVisited : Bool = false
    @Published private(set) var addedToList : Bool = false
    
    private let place : ParkViewModel
    
    init(place: ParkViewModel) {
        self.place = place
        getPark()
    }
    
    func storePark( markVisited : Bool = false) {
        CoreDataManager().storePark(model: self.place)
    }
    
    func getPark()  {
        if let park = CoreDataManager().getPark(id: place.id) {
            self.addedToList = true
            self.isVisited = park.isVisited
        }
    }
    
    func updateParkStatus() {
        if self.addedToList {
           let success = CoreDataManager().deletePark(id: self.place.id)
            if success {
                self.addedToList = false
                self.isVisited = false
            }
        } else {
            CoreDataManager().storePark(model: self.place)
            addedToList = true
        }
    }
    
    func updateVisitStatus() {
        if !self.addedToList {
            CoreDataManager().storePark(model: self.place, markVisited: !self.isVisited)
            getPark()
            return
        }
        
        let updatedSuccess = CoreDataManager().updateParkVisitStatus(id: place.id, isVisited: !isVisited)
        if updatedSuccess {
            self.isVisited.toggle()
        }
    }
}
