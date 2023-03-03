//
//  HomeHostingController.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/27/23.
//

import SwiftUI

class HomeViewHostingController: UIHostingController<HomeScreen> {
    weak var coordinator : HomeCoordinator?
    init() {
        super.init(rootView: HomeScreen())
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(goToDetail(_:)),
                         name: NSNotification.Name ("goToDetailResult"),object: nil)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func goToDetail(_ notification: Notification) {
        if let park = notification.userInfo?["park"] as? ParkViewModel {
            coordinator?.goToDetail(park)
        }
    }
}
//MARK: - UIGestureRecognizerDelegate
extension HomeViewHostingController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return (self.navigationController?.viewControllers.count ?? 0 > 0 )
    }

    // This is necessary because without it, subviews of your top controller can
    // cancel out your gesture recognizer on the edge.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
