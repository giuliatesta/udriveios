//
//  AccelerometerValues.swift
//  udriveios
//
//  Created by Sara Regali on 08/05/23.
//

import Foundation
import SwiftUI
import CoreMotion

class AccelerometerValues{
    var accelerometerValues : (Double, Double, Double) = (0.0,0.0,0.0)
    
    init(accelerometerValues: (Double, Double, Double)) {
        self.accelerometerValues = accelerometerValues
    }
    
    func setValues(_ val : (Double,Double,Double)){
        self.accelerometerValues = val
    }
    
    func getAccelerometerX() -> Double {
        return self.accelerometerValues.0
    }

    func getAccelerometerY() -> Double {
        return self.accelerometerValues.1
    }
    
    func getAccelerometerZ() -> Double {
        return self.accelerometerValues.2
    }
    
    func setAccelerometerX(_ val: Double){
        self.accelerometerValues.0 = val
    }

    func setAccelerometerY(_ val: Double){
        self.accelerometerValues.1 = val
    }
    
    func setAccelerometerZ(_ val: Double){
        self.accelerometerValues.2 = val
    }
    
    func getValuesToString() -> String {
        return "x:" + accelerometerValues.0.toString() + " ; " +
                "y:" + accelerometerValues.1.toString() + " ; " +
                "z:" + accelerometerValues.2.toString()
    }
}
