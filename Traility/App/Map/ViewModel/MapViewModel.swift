//
//  MapViewModel.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/10/23.
//

import Foundation

class MapViewModel : BaseSearchViewModel {
    @Published private(set) var parks : [UUID:ParkViewModel] = [:]
    private var allParks: [UUID:ParkViewModel]? = nil
    private var fetchAllParks : Bool = false
    
    func searchParks(for state : String) {
        self.fetchAllParks = false
        resetParks()
        startRequest(duration: 2) {
            self.searchRequest(params: ["stateCode" : state])
        }
    }
    
    func searchAllParks() {
        self.fetchAllParks = true
        resetParks()
        if let allParks = allParks {
            self.parks = allParks
            return
        }
        DispatchQueue(label: "allparks.concurrent.queue").async {
            if let allParks : ParkModel = try? Bundle.main.decode("nps_data") {
                self.mapRespnseData(response: allParks)
            }
        }
    }
    
    func resetParks() {
        self.parks = [:]
    }
    
    private func searchRequest(params : [String : String]){
        let parkUrl = URLManager().getUrl(endPoint: .parks, params: params)
        APINetworkManager().performRequest(ParkModel.self, from: parkUrl) { [weak self] result in
            switch result {
            case .success(let response) :
                self?.mapRespnseData(response: response)
                
            case .failure(let error) :
                self?.isLoading = false
                print(error.errorDescription ?? "")
            }
        }
    }
    
    private func mapRespnseData(response : ParkModel)  {
        let dataList = response.data
            var viewModels : [UUID:ParkViewModel] = [:]
            for data in dataList {
                let park : ParkViewModel = ParkViewModel(
                    data: data
                )
                park.bindAnnotation()
                viewModels[park.id] = park
            }
            self.bindData(viewModels: viewModels)
    }
    
    private func bindData(viewModels : [UUID:ParkViewModel]) {
        DispatchQueue.main.async {
            if self.fetchAllParks {
                self.allParks = viewModels
            }
            self.parks = viewModels
            self.isLoading = false
        }
    }
    
}
