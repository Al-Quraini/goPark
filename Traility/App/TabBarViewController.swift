//
//  HomeScreenTabBarController.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/9/23.
//

import UIKit
import SwiftUI

class TabBarViewController: UITabBarController {
    
    weak var coordinator : MainCoordinator?
    var mapCoordinator : MapCoordinator?
    var homeCoordinator : HomeCoordinator?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "Home" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HomeScreenReset"), object: self)
        }
    }
    
    private func setup() {
        // view
        view.backgroundColor = .systemBackground
        
        // uitabBar
        UITabBar.appearance().barTintColor = .systemBackground
        
        // appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        // tabBar
        tabBar.tintColor = TrailityColor.dominantColor
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(hideTabBar),
                         name: NSNotification.Name ("HideTabBar"),object: nil)
        
        setupTabs()
        
    }
    
    private func setupTabs() {
        // homeScreen
        let homeScreen = HomeViewHostingController()
        let homeScreenNav = UINavigationController(rootViewController: homeScreen)
        // Enable gesture to pop the top view controller off the navigation stack
        homeCoordinator = HomeCoordinator(navigationController: homeScreenNav)
        homeCoordinator?.startCoordinator(with: homeScreen)
        // mapView
        let mapView = MapViewController()
        let mapViewNav = UINavigationController(rootViewController: mapView)
        // setup coordinator
        mapCoordinator = MapCoordinator(navigationController: mapViewNav)
        mapCoordinator?.startCoordinator(with: mapView)
        
        // set view controllers
        viewControllers = [
            createControllers(for: homeScreenNav, title: "Home", image: UIImage(systemName: "safari") ?? UIImage(), selectedImage: UIImage(systemName: "safari.fill") ?? UIImage()),
            createControllers(for: mapViewNav, title: "Map", image: UIImage(systemName: "map") ?? UIImage(), selectedImage: UIImage(systemName: "map.fill") ?? UIImage()),
        ]
    }
    

    private func createControllers(for navController : UIViewController, title : String, image : UIImage, selectedImage : UIImage) -> UIViewController {
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.tabBarItem.selectedImage = selectedImage
        navController.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        navController.navigationController?.navigationBar.isHidden = true
        edgesForExtendedLayout = []
        
        // send that into our coordinator so that it can display view controllers
//        coordinator = MapCoordinator(navigationController: navController)

        
        return navController
    }
    
    @objc private func hideTabBar(_ notification: Notification) {
        if let hide = notification.userInfo?["hide"] as? Bool {
            tabBar.isHidden = hide
        }
    }

}
