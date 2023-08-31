//
//  Classifier.swift
//  udriveios
//
//  Created by Sara Regali on 05/06/23.
//

import Foundation

class Classifier {
    
    var danger: Bool
    
    init(danger: Bool = true) {
        self.danger = danger
    }
    
    func classify(values: SensorValues, threshold: Double) -> Bool {
        danger = false;
        var timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: { timer in
            self.danger = false;
            timer.invalidate()
        })
        return danger;
    }
}
