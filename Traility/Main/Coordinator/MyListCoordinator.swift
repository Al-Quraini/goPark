//
//  MyListCoordinator.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 3/1/23.
//

import UIKit
import SwiftUI

class MyListCoordinator : Coordinator {
    
    var parentCoordinator: (any Coordinator)?
    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController
    
    
    init(navigationController: UINavigationController) {
         self.navigationController = navigationController
        self.navigationController.navigationBar.isHidden = true
     }
    
    func startCoordinator(with controller: MyListTableViewController) {        
        // navigation
        controller.coordinator = self
        self.navigationController.pushViewController(controller, animated: true)
                
        setupNavigationBarVisibility()
    }
    
    func goToDetail(model : ParkViewModel) {
        let detailController = UIHostingController(rootView: PlaceDetailPage(place: model, detailVM: DetailViewModel(place: model)))
        self.navigationController.pushViewController(detailController, animated: true)
        
    }
    
    func setupNavigationBarVisibility() {
        // setup navigation bar
        navigationController.navigationBar.tintColor = .black
        navigationController.navigationItem.hidesBackButton = false
        navigationController.setNavigationBarHidden(false, animated: true)
        navigationController.navigationBar.prefersLargeTitles = true
    }
    
}
