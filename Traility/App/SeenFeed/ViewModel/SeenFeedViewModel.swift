//
//  SeenFeedViewModel.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/1/23.
//

import Foundation

struct SeenFeedViewModel {
    private let networkManager = APINetworkManager()
    func getPostsData(completion: @escaping ([SeenViewModel]?, Error?) -> Void){
        
//        networkManager.performRequest([SeenModel].self, from: APINetworkURLs.baseURL) { result in
//            switch result {
//            case .success(let models) :
//                getViewModels(models: models)
//                break
//            case .failure(let err) :
//                completion(nil,err)
//                print(err)
//                break
//            }
//        }
        
        func getViewModels(models : [SeenModel]){
            let group = DispatchGroup()
            var postViewModels : [SeenViewModel] = []
//            for model in models {
//                let url : URL? = URL(string: model.reactionVideoURL)
//                
//                group.enter()
//                ImageService().getImageData(model.reactionPlaceholderURL) { data,_ in
//                    if let data = data, let url = url {
//                        let post = SeenViewModel(reactionVideoURL: url, placeHolder: data)
//                        postViewModels.append(post)
//                    }
//                    group.leave()
//                }
//            }
            group.notify(queue: .global(qos: .background), execute: {
                completion(postViewModels, nil)
            })
        }
        
    }
 
}
