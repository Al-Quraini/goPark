//
//  HeaderCollectionReusableView.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/17/23.
//

import UIKit
import SwiftUI

class HeaderCollectionReusableView: UICollectionReusableView {
        
    static let id : String = "HeaderCollectionReusableView"
    
    private let title : UILabel = {
        let label = UILabel()
        label.text = "title"
        label.font = .poppins(size : 18, weight: .semiBold)
        
        return label
    }()
    
    private let stackView : UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 5
        stack.alignment = .center
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 20)
        
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        stackView.addArrangedSubview(title)
        self.addSubview(stackView)
        stackView.frame = self.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title : String) {
        self.title.text = title
    }
}


//MARK: - Shimmer effect
class ShimmerHeaderCollectionReusableView: UICollectionReusableView, SkeletonLoadable {
        
    static let id : String = "ShimmerHeaderCollectionReusableView"
    
    let typeLabel = UILabel()
    let typeLayer = CAGradientLayer()
    
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
        
        typeLayer.frame = CGRect(x: -3, y: -3, width: typeLabel.bounds.width + 4, height: typeLabel.bounds.height + 4)
        typeLayer.cornerRadius = (typeLabel.bounds.height + 4)/2

    }
    
    private func setup() {
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.font = .poppins(size : 18, weight: .semiBold)
        typeLabel.adjustsFontForContentSizeCategory = true
        typeLabel.text = "XXXXXX-XXX"

    }
    
    private func setupLayers() {
        typeLayer.startPoint = CGPoint(x: 0, y: 0.5)
        typeLayer.endPoint = CGPoint(x: 1, y: 0.5)
        typeLabel.layer.addSublayer(typeLayer)

    }
    
    private func setupAnimation() {
        let typeGroup = makeAnimationGroup()
        typeGroup.beginTime = 0.0
        typeLayer.add(typeGroup, forKey: "backgroundColor")
        
    }
    
    private func layout() {
        self.addSubview(typeLabel)
        
        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            typeLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            bottomAnchor.constraint(equalToSystemSpacingBelow: bottomAnchor, multiplier: 1)
            
        ])
    }
    
}
