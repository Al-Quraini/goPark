//
//  Coordinator.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/9/23.
//

import Foundation
import UIKit
import SwiftUI

class MainCoordinator : Coordinator  {
    
    var parentCoordinator: (any Coordinator)?
    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
         self.navigationController = navigationController
     }
    
    func startCoordinator(with controller : ContainerViewController) {
            controller.coordinator = self
            navigationController.setNavigationBarHidden(true, animated: false)
            navigationController.pushViewController(controller, animated: true)
    }
    
    func goToDetail(_ park : ParkViewModel) {
        let detailVC = UIHostingController(rootView: PlaceDetailPage(place: park, detailVM: DetailViewModel(place: park)))
        self.navigationController.pushViewController(detailVC, animated: true)
    }
    
    func goToMyList() {
        let myListCoordinator = MyListCoordinator(navigationController: navigationController)
        myListCoordinator.parentCoordinator = self
        childCoordinators.append(myListCoordinator)
        myListCoordinator.startCoordinator(with: MyListTableViewController())
    }
    
    func sendEmail() {
        MailManager().sendEmail(nav: self.navigationController)
    }
    
    func shareMyApp() {
        ShareManager().shareFacebookApp(nav: self.navigationController)
    }
    
    func hasElments() -> Bool {
        navigationController.viewControllers.count > 1
    }
    func setNavBarHidden(_ isHidden : Bool, controller : UIGestureRecognizerDelegate) {
        self.navigationController.setNavigationBarHidden(isHidden, animated: true)
        self.navigationController.interactivePopGestureRecognizer?.delegate = controller

        // Enable gesture to pop the top view controller off the navigation stack
        self.navigationController.interactivePopGestureRecognizer?.isEnabled = true
    }
    
}
