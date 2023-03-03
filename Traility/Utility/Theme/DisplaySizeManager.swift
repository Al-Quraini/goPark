//
//  DisplaySizeManager.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/5/23.
//

import Foundation
import UIKit

struct DisplaySizeManager {
    static func proportionalFraction() -> CGFloat {
        switch UIScreen.screenHeight {
        case 0..<700 : return 0.7
        case 700..<1000 : return 1
        default : return 1.3
        }
    }
    
    static func getSafeArea() -> UIEdgeInsets? {

            let keyWindow = UIApplication.shared.connectedScenes

                .filter({$0.activationState == .foregroundActive})

                .map({$0 as? UIWindowScene})

                .compactMap({$0})

                .first?.windows

                .filter({$0.isKeyWindow}).first

            

            return (keyWindow?.safeAreaInsets)

        }
}
