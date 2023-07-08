//
//  SensorValues.swift
//  udriveios
//
//  Created by Sara Regali on 08/05/23.
//

import Foundation
import SwiftUI
import CoreMotion

class SensorValues{
    private var _sensorValues :(Double, Double, Double)
    
    public var sensorValues : (Double, Double, Double){
        get {
            // possibly modify the return value
            return self._sensorValues
        }
        set {
            // possibly modify the value being stored
            self._sensorValues = newValue
        }
    }
    
    init(sensorValues: (Double, Double, Double)) {
        self._sensorValues = sensorValues
    }
    
    func getSensorX() -> Double {
        return self.sensorValues.0
    }

    func getSensorY() -> Double {
        return self.sensorValues.1
    }
    
    func getSensorZ() -> Double {
        return self.sensorValues.2
    }
    
    func setSensorX(_ val: Double){
        self.sensorValues.0 = val
    }

    func setSensorY(_ val: Double){
        self.sensorValues.1 = val
    }
    
    func setSensorZ(_ val: Double){
        self.sensorValues.2 = val
    }
    
    func getValuesToString() -> String {
        return "x:" + sensorValues.0.toString() + " ; " +
                "y:" + sensorValues.1.toString() + " ; " +
                "z:" + sensorValues.2.toString()
    }
}
