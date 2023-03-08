//
//  BrowserManager.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 3/2/23.
//

import UIKit

struct LinkManager {
    
    func goToGoParkAppTwitterProfile() {
        let twitterUsername = "goPark_app"
        guard let twitterUrl = URL(string: "twitter://user?screen_name=\(twitterUsername)") else { return }
        let webUrl = URL(string: "https://twitter.com/\(twitterUsername)")!
        
        if UIApplication.shared.canOpenURL(twitterUrl) {
            // Twitter app is installed, open user profile
            UIApplication.shared.open(twitterUrl, options: [:], completionHandler: nil)
        } else {
            // Twitter app is not installed, open user profile in web browser
            UIApplication.shared.open(webUrl, options: [:], completionHandler: nil)
        }
    }
    
    func goToNPSPage() {
        guard let webUrl = URL(string: "https://www.nps.gov/index.htm") else { return }
            // Twitter app is not installed, open user profile in web browser
            UIApplication.shared.open(webUrl, options: [:], completionHandler: nil)
    }
}
