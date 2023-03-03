//
//  DealsFooterCollectionReusableView.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/17/23.
//

import UIKit

class DealsFooterCollectionReusableView: UICollectionReusableView {
    static let id : String = "DealsFooterCollectionReusableView"
    
    private let myView : UIView  = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let shimmerLayer = CAGradientLayer()

      
    private var dotViews: [UIView] = []
    var numberOfDots = 3 {
        didSet {
            updateDots()
        }
    }
    var dotColor = UIColor.lightGray {
        didSet {
            updateDots()
        }
    }
    var dotSpacing: CGFloat = 8 {
        didSet {
            updateDots()
        }
    }
    var dotSize: CGFloat = 8 {
        didSet {
            updateDots()
        }
    }

    var currentDotIndex = 0 {
        didSet {
            updateCurrentDot()
        }
    }
    var dotAnimationDuration: TimeInterval = 0.3
    private var dotAnimation: CABasicAnimation?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        updateDots()
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
    
    private func layout() {
        self.layer.cornerRadius = 6
        self.clipsToBounds = true
        self.addSubview(myView)
        NSLayoutConstraint.activate([
            myView.widthAnchor.constraint(equalToConstant: 75),
            myView.heightAnchor.constraint(equalToConstant: 20),
            myView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            myView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }

    private func updateDots() {
        dotViews.forEach { $0.removeFromSuperview() }
        dotViews = (0..<numberOfDots).map { _ in
            let dotView = UIView()
            dotView.backgroundColor = dotColor
            dotView.layer.cornerRadius = dotSize / 2
            dotView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(dotView)
            return dotView
        }

        let constraints = dotViews.enumerated().flatMap { index, dotView in
            [
                dotView.widthAnchor.constraint(equalToConstant: dotSize),
                dotView.heightAnchor.constraint(equalToConstant: dotSize),
                dotView.centerYAnchor.constraint(equalTo: centerYAnchor),
                dotView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: CGFloat(index - (numberOfDots - 1) / 2) * (dotSize + dotSpacing))
            ]
        }
        NSLayoutConstraint.activate(constraints)
        updateCurrentDot()
    }
    
    private func updateCurrentDot() {
        dotAnimation = CABasicAnimation(keyPath: "backgroundColor")
        dotAnimation?.duration = dotAnimationDuration
        dotAnimation?.fromValue = dotColor.cgColor
        dotAnimation?.toValue = TrailityColor.dominantColor.cgColor
        dotAnimation?.fillMode = .forwards
        dotAnimation?.isRemovedOnCompletion = false
        
        dotViews.enumerated().forEach { index, dotView in
            if index == currentDotIndex {
                dotView.layer.add(dotAnimation!, forKey: "dotAnimation")
                dotView.backgroundColor = TrailityColor.dominantColor
            } else {
                dotView.layer.removeAllAnimations()
                dotView.backgroundColor = dotColor
            }
        }
    }
}

extension DealsFooterCollectionReusableView : SkeletonLoadable {
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
    
    func addShimmerEffect() {
        myView.layer.addSublayer(shimmerLayer)
        shimmerLayer.frame = myView.bounds
        shimmerLayer.cornerRadius = myView.bounds.height/2
    }
    
    func removeShimmerEffect() {
        shimmerLayer.removeAllAnimations()
        shimmerLayer.removeFromSuperlayer()
    }
}
