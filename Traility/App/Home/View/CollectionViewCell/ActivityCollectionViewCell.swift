//
//  ActivityCollectionViewCell.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/24/23.
//

import UIKit

class ActivityCollectionViewCell : UICollectionViewCell {
    
    static let id : String = "ActivityCollectionViewCell"
    
    private let imageView : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        
        return image
    }()
    
    private let title : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .poppins(size : 13, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        
        return label
    }()
    
    private let blackTransparentLayer : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.opacity = 0.6
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.image = nil
    }
    
}

extension ActivityCollectionViewCell {
    
    private func setup() {
        self.layer.cornerRadius = 6
        self.layer.shadowColor = UIColor.systemGray4.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: -2, height: 1)
        self.clipsToBounds = true
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(blackTransparentLayer)
        self.contentView.addSubview(title)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
            blackTransparentLayer.topAnchor.constraint(equalTo: imageView.topAnchor),
            blackTransparentLayer.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            blackTransparentLayer.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            blackTransparentLayer.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            
            title.centerXAnchor.constraint(equalTo: blackTransparentLayer.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: blackTransparentLayer.centerYAnchor),
            title.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 5),
            title.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -5),
        ])
    }
    
}

extension ActivityCollectionViewCell : CellConfigurable {
    static var identifier: String = id
    

    func configureCell(with model : ActivityVM) {
        self.title.text = model.name
        if let imageName = ACTIVITIES.activitesDict[model.id],
           let image = UIImage(named: imageName) {
            self.imageView.image = image
        }
    }
}


//MARK: - ShimmerFeatureCollectionViewCell
class ShimmerActivityCollectionViewCell : UICollectionViewCell, SkeletonLoadable {
    
    static let id : String = "ShimmerActivityCollectionViewCell"
    
    let shimmerLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayers()
        setupAnimation()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}

extension ShimmerActivityCollectionViewCell {
    
    
    private func layout() {
        self.layer.cornerRadius = 6
        self.clipsToBounds = true
        
        self.layer.addSublayer(shimmerLayer)
        shimmerLayer.frame = self.bounds
    }
    
    private func setupLayers() {
        shimmerLayer.startPoint = CGPoint(x: 0, y: 0.5)
        shimmerLayer.endPoint = CGPoint(x: 1, y: 0.5)
        self.layer.addSublayer(shimmerLayer)
        
    }
    
    private func setupAnimation() {
        let shimmerGroup = makeAnimationGroup()
        shimmerGroup.beginTime = 0.0
        shimmerLayer.add(shimmerGroup, forKey: "backgroundColor")
    }
}

