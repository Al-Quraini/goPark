//
//  ShimmerCollectionViewCelll.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/15/23.
//

import UIKit

class NearbyForYouCollectionViewCell: UICollectionViewCell {
    static let id : String = "NearbyForYouCollectionViewCell"
    
    private let imageView : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 12
        
        return image
    }()
    
    private let name : UILabel = {
        let label = UILabel()
        label.font = .poppins(size : 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    private let location : UILabel = {
        let label = UILabel()
        label.font = .poppins(size : 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        self.imageView.image = nil
        self.name.text = nil
        self.location.text = nil
    }
}

extension NearbyForYouCollectionViewCell {
    
    private func setup() {
        self.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        contentView.addSubview(imageView)
        contentView.addSubview(name)
        contentView.addSubview(location)

    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            // image view
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: name.topAnchor, constant: -5),
            
            // name
            name.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            name.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            name.bottomAnchor.constraint(equalTo: location.topAnchor, constant: -3),
            
            // location
            location.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            location.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            location.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
    }
}


extension NearbyForYouCollectionViewCell : CellConfigurable {
    static var identifier: String = id
    
    typealias Model = ParkViewModel
    
    func configureCell(with model: ParkViewModel) {
        self.imageView.loadImage(model.image)
        self.name.text = model.name
        self.location.text = "\(model.city), \(model.state)"
    }
    
}

//MARK: - Shimmer
class ShimmerNearbyForYouCollectionViewCell: UICollectionViewCell {
    static let id : String = "ShimmerNearbyForYouCollectionViewCell"
    
    private let imageView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let name : UILabel = {
        let label = UILabel()
        label.font = .poppins(size : 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "-----xx------xx-----xx----"
        label.textColor = .clear
        return label
    }()

    private let location : UILabel = {
        let label = UILabel()
        label.font = .poppins(size : 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "---xx----xx---"
        label.textColor = .clear
        return label
    }()

    let imageLayer = CAGradientLayer()
    let nameLayer = CAGradientLayer()
    let locationLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        setupLayers()
        setupAnimation()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
       addShimmerEffect()
    }
    
    private func addShimmerEffect() {
        imageLayer.frame = imageView.bounds
        imageLayer.cornerRadius = 12
        
        nameLayer.frame = name.bounds
        nameLayer.cornerRadius = name.bounds.height/2
        
        locationLayer.frame = location.bounds
        locationLayer.cornerRadius = location.bounds.height/2
    }
    
}

extension ShimmerNearbyForYouCollectionViewCell : SkeletonLoadable {
    
    private func setup() {
        self.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        

    }
    
    private func setupLayers() {
        imageLayer.startPoint = CGPoint(x: 0, y: 0.5)
        imageLayer.endPoint = CGPoint(x: 1, y: 0.5)
        imageView.layer.addSublayer(imageLayer)
        
        nameLayer.startPoint = CGPoint(x: 0, y: 0.5)
        nameLayer.endPoint = CGPoint(x: 1, y: 0.5)
        name.layer.addSublayer(nameLayer)

        locationLayer.startPoint = CGPoint(x: 0, y: 0.5)
        locationLayer.endPoint = CGPoint(x: 1, y: 0.5)
        location.layer.addSublayer(locationLayer)
        
    }
    
    private func setupAnimation() {
        let imageGroup = makeAnimationGroup()
        imageGroup.beginTime = 0.0
        imageLayer.add(imageGroup, forKey: "backgroundColor")
        
        let nameGroup = makeAnimationGroup(previousGroup: imageGroup)
        nameLayer.add(nameGroup, forKey: "backgroundColor")
        
        let locationGroup = makeAnimationGroup(previousGroup: nameGroup)
        locationLayer.add(locationGroup, forKey: "backgroundColor")

    }
    
    private func layout() {
        contentView.addSubview(imageView)
        contentView.addSubview(name)
        contentView.addSubview(location)
        
        NSLayoutConstraint.activate([
            // image view
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: name.topAnchor, constant: -5),
            
            // name
            name.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            name.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            name.bottomAnchor.constraint(equalTo: location.topAnchor, constant: -3),
            
            // location
            location.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            location.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            location.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
    }
}
