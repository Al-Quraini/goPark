//
//  HomeViewModel.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/18/23.
//

import Foundation
import SwiftUI

class HomeViewModel : BaseSearchViewModel {
    @Published private(set) var isAppBarHidden : Bool = false
    @Published private(set) var searchResult : ResultState = .initial
    @Published private(set) var nearbyParks : [ParkViewModel]? = nil
    @Published private(set) var forYouParks : [ParkViewModel]? = nil
    @Published private(set) var activities : [ActivityVM]? = nil
    @Published private(set) var activityItems : [ParksForActivityViewModel]? = nil
    @Published private(set) var showLoadingIndicator : Bool = false
    @Published private(set) var initialDisply : Bool = false
    static let allParks : [ParkViewModel] = {
        if let parksData : ParkModel = try? Bundle.main.decode("nps_data") {
            let parks : [ParkViewModel] = parksData.data.map { data in
                let viewModel : ParkViewModel = ParkViewModel(
                    data: data
                )
                return viewModel
            }
            return parks
        }
        return []
    }()

    // hiding top nav bar
    private var isHidden : Bool = false {
        didSet {
            if isHidden != oldValue {
                isAppBarHidden = isHidden
            }
        }
    }
    
    
    // search parks with text
    func search(for text : String) {
        if text.count < 3 {return}
        startRequest(duration: 0.25) {
            self.parksSearchRequest(params: ["q" : text, "limit" : String(25)])
        }
    }
    

    
    func searchNearby(for state : String) {
        searchPark(with: ["stateCode" : state])
    }
    
    // search parks with text
    func searchParks(for activity : ActivityVM) {
        showLoadingIndicator = true
        self.activitiesParksSearchRequest(params: ["id" : activity.id.uuidString, "limit" : String(20)])
    }
    
    func createInitialServiceRequest(_ state : String?) {
        let group = DispatchGroup()
        if let state = state {
            group.enter()
            searchPark(with: ["stateCode" : state], group: group)
        } else {
            group.enter()
            self.searchPark(with: ["limit": "\(8)"], group: group)
        }
        group.enter()
        getActivities(group: group)
        
        group.notify(queue: .main) {
            self.initialDisply = false
        }
    }
    
    // fetch activities from local json file
    func getActivities(group : DispatchGroup? = nil) {
        DispatchQueue(label: "activities.queue").async {
            if let activities : ActivityModel = try? Bundle.main.decode("nps_activities") {
                let activitiesVM : [ActivityVM] = activities.data.map { data in
                    let viewModel : ActivityVM = ActivityVM(id: data.id.toUUID(), name: data.name)
                    return viewModel
                }
                
                var filteredActivities : [ActivityVM] = []
                
                for activity in activitiesVM {
                    if let _ = ACTIVITIES.activitesDict[activity.id]{
                        filteredActivities.append(activity)
                    }
                }
                DispatchQueue.main.async {
                    self.activities = filteredActivities
                    group?.leave()
                }
            }
        }
    }
    
    // search nearby by state code
    func searchPark(with params : [String:String]?, group : DispatchGroup? = nil) {
        let url = URLManager().getUrl(endPoint: .parks, params: params)
        APINetworkManager().performRequest(ParkModel.self, from: url) { [weak self] result in
            guard let self = self else { group?.leave(); return }
            switch result {
            case .success(let response) :
                let viewModels = DataMapper().mapRespnseData(response: response)
                DispatchQueue.main.async {
                    self.nearbyParks = !viewModels.isEmpty ? viewModels : []
                    self.isLoading = false
                    group?.leave()
                }
                
            case .failure(let error) :
                DispatchQueue.main.async {
                    self.isLoading = false
                    group?.leave()
                    print(error.errorDescription ?? "")
                }
            }
        }
    }
    
    
    // filter parks based on text
    func filterPark(for text : String) {
        if text.isEmpty {
            self.searchResult = .initial
        }
        DispatchQueue(label: "filterparks.queue").async {
            let filteredParks = HomeViewModel.allParks.filter({$0.name.lowercased().contains(text.lowercased())}).prefix(15)
            
            DispatchQueue.main.async {
                self.searchResult = filteredParks.isEmpty ? .none : .some(Array(filteredParks))
            }
        }
    }
    
    // create api search request
    private func parksSearchRequest(params : [String : String]){
        let parkUrl = URLManager().getUrl(endPoint: .parks, params: params)
        APINetworkManager().performRequest(ParkModel.self, from: parkUrl) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response) :
                let viewModels = DataMapper().mapRespnseData(response: response)
                DispatchQueue.main.async {
                    self.searchResult = !viewModels.isEmpty ? .some(viewModels) : .none
                    self.isLoading = false
                }
                
            case .failure(let error) :
                self.isLoading = false
                print(error.errorDescription ?? "")
            }
        }
    }
    
    // activities parks search request
    private func activitiesParksSearchRequest(params : [String : String]){
        let url = URLManager().getUrl(endPoint: .activiesParks, params: params)
        print(url)
        APINetworkManager().performRequest(ParkActivityModel.self, from: url) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response) :
                guard let parks = response.data.first?.parks else { return }
                let viewModels = parks.map { park in
                    return ParksForActivityViewModel(decodable: park, activityName: response.data.first?.name, id: response.data.first?.id)
                }
                DispatchQueue.main.async {
                    self.activityItems = viewModels
                    self.showLoadingIndicator = false
                }
                
            case .failure(let error) :
                self.showLoadingIndicator = false
                print(error.errorDescription ?? "")
            }
        }
    }
    
    
    func clearSearch() {
        searchResult = .initial
    }
    
    func updateAppBarVisibility(_ isHidden : Bool) {
        self.isHidden = isHidden
    }
    
    enum ResultState {
        case initial
        case some([ParkViewModel])
        case none
    }
}


//MARK: - Data Mapper
private struct DataMapper {
    // map response data into view models
     fileprivate func mapRespnseData(response : ParkModel) -> [ParkViewModel] {
            let dataList = response.data
            let viewModels : [ParkViewModel] = dataList.map { data in
                let viewModel : ParkViewModel = ParkViewModel(
                    data: data
                )
                return viewModel
            }
        return viewModels
    }
}
