//
//  ClickableStackView.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/28/23.
//

import UIKit

class ClickableStackView : ClickableView {
    private let imageName : String
    private let text : String
    
    private let stackView : UIStackView = UIStackView()
    
    init(imageName : String , text : String, perform : @escaping () -> ()) {
        self.imageName = imageName
        self.text = text
        super.init(perform: perform)
        
        setup()
        layout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ClickableStackView {
    private func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        
        setupStackView()

    }
     private func setupStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        
        let title = UILabel()
        title.font = .poppins(size: 13, weight: .regular)
        title.text = self.text
        
        let icon = UIImageView(image: UIImage(systemName: self.imageName))
        icon.tintColor = .black
        icon.clipsToBounds = true
        icon.contentMode = .scaleAspectFit
        
        stackView.addArrangedSubview(icon)
        stackView.addArrangedSubview(title)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

