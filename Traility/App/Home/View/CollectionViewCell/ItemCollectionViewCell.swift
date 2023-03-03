//
//  ItemCollectionViewCell.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/16/23.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    static let id : String = "ItemCollectionViewCell"
    
    private let imageView = UIImageView(image: UIImage(named: AssetImageName.appIcon))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(url : String?) {
    }
    
    
}
