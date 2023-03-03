//
//  ClickableView.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 3/1/23.
//

import UIKit

class ClickableView : UIView {
    private let perform : () -> ()
    
    init(perform : @escaping () -> ()) {
        self.perform = perform
        super.init(frame: .zero)

        addGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         DispatchQueue.main.async {
             self.alpha = 1.0
             UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
                 self.alpha = 0.3
             }, completion: nil)
         }
     }

     override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
         DispatchQueue.main.async {
             self.alpha = 0.3
             UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
                 self.alpha = 1.0
             }, completion: nil)
         }
     }

     override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
         DispatchQueue.main.async {
             self.alpha = 0.3
             UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: {
                 self.alpha = 1.0
             }, completion: nil)
         }
     }
    
    private func addGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc
    private func didTap(_ gesture : UITapGestureRecognizer) {
        perform()
    }
}
