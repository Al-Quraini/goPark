//
//  Coordinator.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/26/23.
//

import Foundation
import UIKit

protocol Coordinator {
    associatedtype ViewController : UIViewController
    
    var parentCoordinator : (any Coordinator)? { get set }
    var childCoordinators: [any Coordinator] { get }
    var navigationController : UINavigationController { get }
    
    func startCoordinator(with controller : ViewController)
}
