//
//  ParkServiceManager.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 3/1/23.
//

import Foundation

struct ParkServiceManager {
    
    // create api search request
    private func parksSearchRequest(params : [String : String], completion :
                                    @escaping (Result<[ParkViewModel],APINetworkError>) -> ()){
        let parkUrl = URLManager().getUrl(endPoint: .parks, params: params)
        APINetworkManager().performRequest(ParkModel.self, from: parkUrl) { result in
            switch result {
            case .success(let response) :
                let viewModels = DataMapper().mapRespnseData(response: response)
                
                completion(.success(viewModels))
                
            case .failure(let error) :
                completion(.failure(.other(error)))
            }
        }
    }
    
    
    // activities parks search request
    private func activitiesParksSearchRequest(params : [String : String], completion : @escaping (Result<[ParksForActivityViewModel],APINetworkError>) -> ()){
        let url = URLManager().getUrl(endPoint: .activiesParks, params: params)
        print(url)
        APINetworkManager().performRequest(ParkActivityModel.self, from: url) { result in
            switch result {
            case .success(let response) :
                guard let parks = response.data.first?.parks else { completion(.failure(.badURL)); return }
                let viewModels = parks.map { park in
                    return ParksForActivityViewModel(decodable: park, activityName: response.data.first?.name, id: response.data.first?.id)
                }
                
                completion(.success(viewModels))
                
            case .failure(let error) :
                completion(.failure(.other(error)))
            }
        }
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
