//
//  MyListTableViewCell.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/28/23.
//

import UIKit

class MyListTableViewCell: UITableViewCell {
    
    static let id : String = "MyListTableViewCell"
    
    private let image : UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 12
        image.backgroundColor = .systemGray5
        
        return image
    }()
    
    
    let placeName : UILabel = {
        let label = UILabel()
        label.font = .poppins(size: 13, weight: .semiBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left

        return label
    }()
    
    let placeLocation : UILabel = {
        let label = UILabel()
        label.font = .poppins(size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left

        return label
    }()
    
    let checkMark : UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
         image.translatesAutoresizingMaskIntoConstraints = false
         image.clipsToBounds = true
         image.contentMode = .scaleAspectFill
        image.tintColor = .systemGreen
         
         return image
     }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
}

extension MyListTableViewCell {
    private func setup() {
        self.contentView.addSubview(image)
        self.contentView.addSubview(placeName)
        self.contentView.addSubview(placeLocation)
        self.contentView.addSubview(checkMark)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12),
            image.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12),
            image.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12),
//            image.heightAnchor.constraint(equalToConstant: 85),
            image.widthAnchor.constraint(equalTo: image.heightAnchor, multiplier: 10/9),
            
            placeName.topAnchor.constraint(equalTo: image.topAnchor, constant: 10),
            placeName.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 15),
            placeName.trailingAnchor.constraint(equalTo: checkMark.leadingAnchor, constant: -5),
            
            
            placeLocation.topAnchor.constraint(equalTo: placeName.bottomAnchor, constant: 3),
            placeLocation.leadingAnchor.constraint(equalTo: placeName.leadingAnchor),
            placeLocation.trailingAnchor.constraint(equalTo: placeName.trailingAnchor),
            
            checkMark.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            checkMark.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
            checkMark.widthAnchor.constraint(equalToConstant: 30),
            checkMark.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    func configure(for model : ParkViewModel) {
        self.image.loadImage(model.image)
        self.placeName.text = model.name
        self.placeLocation.text = "\(model.city), \(model.state)"
        self.checkMark.tintColor = model.isVisited ? .systemGreen : .systemGray5
    }
}
