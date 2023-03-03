//
//  UIImageViewExtension.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/15/23.
//

import UIKit

extension UIImageView {
    func loadImage(_ url : String?, showLoader : Bool = false) {
        var spinner : UIActivityIndicatorView?

        if showLoader {
            setupLoader()
        }
        spinner?.startAnimating()
        self.backgroundColor = .systemGray5
        ImageManager().getImageCompletion(url: url) { [weak self] state in
            guard let self = self else {return}
            DispatchQueue.main.async{
                switch state {
                case .loading :
                    break
                case .loaded(let image) :
                    self.image = image
                    self.contentMode = .scaleAspectFill
                    spinner?.stopAnimating()
                case .noImage:
                    self.image = UIImage(systemName: "photo")
                    self.image?.withTintColor(.systemGray4)
                    self.contentMode = .scaleAspectFit
                    spinner?.stopAnimating()
                }
            }
        }
        
        func setupLoader() {
            spinner = UIActivityIndicatorView()
            guard let spinner = spinner else { return }
            spinner.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(spinner)
            
            NSLayoutConstraint.activate([
                spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            ])
            
        }
    }
}
