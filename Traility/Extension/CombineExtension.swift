//
//  CombineExtension.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/10/23.
//

import Foundation
import Combine

typealias CancelBag = Set<AnyCancellable>

extension CancelBag {
  mutating func cancelAll() {
    forEach { $0.cancel() }
    removeAll()
  }
}
