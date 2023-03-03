//
//  SeeAllButton.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/10/23.
//

import UIKit

class SeeAllButton : UIButton {

    var onSelection : (() -> ())?
    var isLoading : Bool = false {
        didSet {
            self.isEnabled = !isLoading
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }
    
    private func setup() {
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .large
        self.configuration = configuration
        setButtonUI()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.alpha = 0.8
        self.addTarget(self, action: #selector(onButtonClicked), for: .touchUpInside)
    }
    
    @objc
    private func onButtonClicked(_ button : UIButton) {
        self.isSelected.toggle()
        setButtonUI()
    }
    
    private func setButtonUI() {
        onSelection?()
        self.configuration?.baseBackgroundColor = self.isSelected ? TrailityColor.dominantColor : .white
        self.configuration?.baseForegroundColor = self.isSelected ? .white : TrailityColor.dominantColor
        self.configuration?.title = self.isSelected ? "Show less" : "Show all parks"
        self.configuration?.image = self.isSelected ? UIImage(systemName: "checkmark.circle.fill") : nil
        self.configuration?.imagePadding = 15
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
