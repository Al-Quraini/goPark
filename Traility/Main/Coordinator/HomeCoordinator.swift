//
//  HomeCoordinator.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 3/2/23.
//

import UIKit
import SwiftUI

class HomeCoordinator : Coordinator  {
    
    var parentCoordinator: (any Coordinator)?
    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
         self.navigationController = navigationController
        self.navigationController.navigationBar.isHidden = true
     }
    
    
    func startCoordinator(with controller: HomeViewHostingController) {
        controller.coordinator = self
            setupRecognizer(controller)
    }
    
    func goToDetail(_ park : ParkViewModel) {
        let detailVC = UIHostingController(rootView: PlaceDetailPage(place: park, detailVM: DetailViewModel(place: park)))
        self.navigationController.pushViewController(detailVC, animated: true)
    }
    
    func hasElments() -> Bool {
        navigationController.viewControllers.count > 1
    }
    
    func setupRecognizer(_ controller : UIGestureRecognizerDelegate) {
        self.navigationController.interactivePopGestureRecognizer?.delegate = controller

        // Enable gesture to pop the top view controller off the navigation stack
        self.navigationController.interactivePopGestureRecognizer?.isEnabled = true
    }
    
}

