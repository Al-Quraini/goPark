//
//  StringExtension.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/23/23.
//

import Foundation

extension String? {
    var isEmptyOrNil: Bool {
            return self?.isEmpty ?? true
        }
    
    var unkownWhenNil : String {
        guard let self = self else { return "N/A"}
        return self
    }
    
    func toUUID() -> UUID {
        if
            let self = self,
            let uuid = UUID(uuidString: self),
            !isEmptyOrNil {
            return uuid
        }
        return UUID()
    }
}

extension String {
    func toUUID() -> UUID {
        if
            let uuid = UUID(uuidString: self) {
            return uuid
        }
        return UUID()
    }
}
