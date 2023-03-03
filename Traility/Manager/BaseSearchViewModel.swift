//
//  BaseSearchViewModel.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/10/23.
//

import Foundation

internal class BaseSearchViewModel : ObservableObject {
    @Published var isLoading : Bool = false
    let timer = TimerManager()
    
    func startRequest(duration : Double, perform : @escaping () -> ()) {
        isLoading = true
        timer.start(withTimeInterval: duration, onFire: perform)
    }
    
}
