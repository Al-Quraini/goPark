//
//  ConfigurableCell.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/20/23.
//

import UIKit

protocol CellConfigurable : UICollectionViewCell {
    associatedtype Model
    static var identifier : String {get}
    func configureCell(with model : Model)
}
