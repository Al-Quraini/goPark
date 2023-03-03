//
//  ReloadButton.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/11/23.
//

import UIKit

class LoaderButton: UIButton {
    var spinner = UIActivityIndicatorView()
    var onTap : (() -> ())?
    var isLoading = false {
        didSet {
            // whenever `isLoading` state is changed, update the view
            updateView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        alpha = 0.8
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .systemOrange
        configuration.buttonSize = .large
        configuration.title = "Reload"
        self.configuration = configuration
        addTarget(self, action: #selector(onButtonClicked), for: .touchUpInside)
        
        setupSpinner()
    }
    
    @objc
    private func onButtonClicked(_ button : UIButton) {
        onTap?()
    }
 
    private func setupSpinner() {
        spinner.hidesWhenStopped = true
        spinner.color = .white
        spinner.style = .medium
        
        // 6
        // add as button subview
        addSubview(spinner)
        // set constraints to always in the middle of button
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    // 7
    func updateView() {
        if isLoading {
            spinner.startAnimating()
            titleLabel?.alpha = 0.2
            imageView?.alpha = 0
            // to prevent multiple click while in process
            isEnabled = false
        } else {
            spinner.stopAnimating()
            titleLabel?.alpha = 1
            imageView?.alpha = 0
            isEnabled = true
        }
    }
}
