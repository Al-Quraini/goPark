//
//  UIApplicationExtension.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/28/23.
//

import UIKit

extension UIApplication {
    static var appVersion : String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0.0"
    }
}
