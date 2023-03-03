//
//  CreditFooterCollectionViewCell.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/24/23.
//

import UIKit

class CreditFooterCollectionViewCell: UICollectionViewCell {
    
    struct CreditData {
        let title : String
        let imageName : String
        let url : String
    }
    
    static let id : String = "CreditFooterCollectionViewCell"
    
    private let imageView : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        
        return image
    }()
    
    private let title : UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .poppins(size : 12, weight: .medium)
        label.numberOfLines = 0
        label.textColor = .white
    
        return label
    }()
    
    private let button : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .large
        configuration.baseBackgroundColor = TrailityColor.primary
        configuration.title = "Visist"
        button.configuration = configuration
        
        return button
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CreditFooterCollectionViewCell {
    
    private func setup() {
        self.contentView.clipsToBounds = true
        self.contentView.backgroundColor = .black
        self.contentView.layer.opacity = 0.85
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(title)
        self.contentView.addSubview(button)
        
        button.addTarget(self, action: #selector(onTap), for: .touchUpInside)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 15),
            imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            imageView.widthAnchor.constraint(equalToConstant: 85),
            imageView.heightAnchor.constraint(equalToConstant: 85),
            
            title.topAnchor.constraint(equalTo: imageView.topAnchor),
            title.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15),
            title.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            title.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -10),

            button.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
            button.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12),
            button.widthAnchor.constraint(equalToConstant: 105),
            button.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    @objc private func onTap() {
        LinkManager().goToNPSPage()
    }
}

extension CreditFooterCollectionViewCell : CellConfigurable {
    static var identifier: String = id
    
    func configureCell(with model: CreditData) {
        self.title.text = model.title
        if let image = UIImage(named: model.imageName) {
            self.imageView.image = image
        }
        
    }
}

//MARK: - ShimmerFeatureCollectionViewCell
class ShimmerCreditFooterCollectionViewCell : UICollectionViewCell, SkeletonLoadable {
    
    static let id : String = "ShimmerCreditFooterCollectionViewCell"
    
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

extension ShimmerCreditFooterCollectionViewCell {
    
    
    private func layout() {
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

