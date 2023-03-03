//
//  TimerManager.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/10/23.
//

import Foundation

class TimerManager {
    private var timer: Timer?
    var onFire: (() -> Void)?
    
    var isRunning: Bool {
        timer != nil && timer!.isValid
    }
    
    @objc
    fileprivate func handleTimerEvent() {
        onFire?()
    }
    
    func start(withTimeInterval timeInterval: TimeInterval,
               repeats: Bool = false,
               onFire: @escaping () -> Void) {
        guard !isRunning else { return }
        timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                     target: self,
                                     selector: #selector(handleTimerEvent),
                                     userInfo: nil, repeats: repeats)
        self.onFire = onFire
    }
        
    func stop() {
        timer?.invalidate()
        timer = nil
        onFire = nil
    }
}
