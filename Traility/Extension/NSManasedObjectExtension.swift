//
//  NSmanasedObjectExtension.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/25/23.
//

import Foundation
import CoreData

extension NSManagedObject {
    public static var entityName : String {
        return String(describing: self.self)
    }
}
