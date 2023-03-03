//
//  MapCoordinator.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/26/23.
//

import UIKit
import SwiftUI

class MapCoordinator : Coordinator  {
    
    var parentCoordinator: (any Coordinator)?
    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
         self.navigationController = navigationController
        self.navigationController.navigationBar.isHidden = true
     }
    
    
    func startCoordinator(with controller: MapViewController) {
            controller.coordinator = self
            setupRecognizer(controller)
    }
    
    func showAlertFalure() {
        let alert = UIAlertController(title: "", message: "Please enable the access to location services", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "ok", style: .default, handler: { (action) in
            // Handle dismissal of alert
        })
        alert.addAction(dismissAction)
        self.navigationController.present(alert, animated: true)
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
