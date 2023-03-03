//
//  DealCollectionViewCell.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/20/23.
//

import UIKit

class FeatureCollectionViewCell : UICollectionViewCell {
    
    struct FeatureData {
        let imageName : String
        let title : String
    }
    
    static let id : String = "FeatureCollectionViewCell"
    
    private let imageView : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        
        return image
    }()
    
    private let gradiantView : UIView = UIView()
    
    private let title : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .poppins(size : 18, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .white
        
        return label
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
        removeGradiant()
        self.imageView.image = nil
        self.title.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addGradiant()
    }
    
}

extension FeatureCollectionViewCell {
    
    private func setup() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(gradiantView)
        self.contentView.addSubview(title)
        
        addGradiant()
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
            title.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            title.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20),
            title.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
        ])
    }
    
    private func addGradiant() {
        self.gradiantView.frame = self.contentView.bounds
        let gradientLayer : CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = gradiantView.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.0]
        if gradiantView.layer.sublayers == nil {
            gradiantView.layer.addSublayer(gradientLayer)
        } else if let layers = gradiantView.layer.sublayers, layers.count < 1 {
            gradiantView.layer.addSublayer(gradientLayer)
        }
    }
    
    private func removeGradiant() {
        self.gradiantView.layer.sublayers?.removeAll()
        
    }
    
}

extension FeatureCollectionViewCell : CellConfigurable {
    static var identifier: String = id
    

    func configureCell(with model : FeatureData) {
        self.imageView.image = UIImage(named: model.imageName)
        self.title.text = model.title
    }
}


//MARK: - ShimmerFeatureCollectionViewCell
class ShimmerFeatureCollectionViewCell : UICollectionViewCell, SkeletonLoadable {
    
    static let id : String = "ShimmerFeatureCollectionViewCell"
    
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

extension ShimmerFeatureCollectionViewCell {
    
    
    private func layout() {
        self.layer.cornerRadius = 10
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
