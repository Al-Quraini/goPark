//
//  ShareManager.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 3/2/23.
//

import UIKit

struct ShareManager {
    func shareFacebookApp(nav : UINavigationController) {
        guard let facebookAppUrl = URL(string: "") else { return }
        let activityViewController = UIActivityViewController(activityItems: [facebookAppUrl], applicationActivities: nil)
        nav.present(activityViewController, animated: true, completion: nil)
    }
}
