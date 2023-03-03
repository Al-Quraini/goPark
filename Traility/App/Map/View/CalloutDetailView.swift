//
//  CalloutDetailView.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/12/23.
//

import Foundation
import UIKit

class CalloutDetailView : UIView, Identifiable {
    weak var delegate : CalloutDelegate?
    let id: UUID
    let name : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "park name"
        label.font = .poppins(size : 14, weight: .medium)
        return label
    }()
    
    let location : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "park name"
        label.font = .poppins(size : 12, weight: .light)

        return label
    }()
    
    let imageView : UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        
        return image
    }()
    
    init(id : UUID) {
        self.id = id
        super.init(frame: .zero)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        self.addGestureRecognizer(tap)
        
        self.clipsToBounds = true
        self.addSubview(imageView)
        self.addSubview(name)
        self.addSubview(location)
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            
            name.topAnchor.constraint(equalTo: imageView.topAnchor),
            name.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            name.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            
            location.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5),
            location.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            location.trailingAnchor.constraint(equalTo: name.trailingAnchor)
        ])
    }
    
    func configureCallout(annotation : ParkAnnotation) {
        self.name.text = annotation.name
        self.location.text = annotation.location
        self.imageView.loadImage(annotation.imageUrl)
    }
    
    @objc
    private func handleTap() {
        delegate?.calloutTapped(id: self.id)
    }
}
