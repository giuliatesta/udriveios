import Foundation
import SwiftUI
import CoreMotion

class SensorValues {
    var accelerometerX : Double;
    var accelerometerY : Double;
    var accelerometerZ : Double;
    var gyroscopeX : Double;
    var gyroscopeY : Double;
    var gyroscopeZ : Double;
    
    init(accelerometerX: Double, accelerometerY: Double, accelerometerZ: Double, gyroscopeX: Double, gyroscopeY: Double, gyroscopeZ: Double) {
        self.accelerometerX = accelerometerX
        self.accelerometerY = accelerometerY
        self.accelerometerZ = accelerometerZ
        self.gyroscopeX = gyroscopeX
        self.gyroscopeY = gyroscopeY
        self.gyroscopeZ = gyroscopeZ
    }
    
    init(accelerometer : (Double, Double, Double), gyroscope: (Double, Double, Double)) {
        self.accelerometerX = accelerometer.0
        self.accelerometerY = accelerometer.1
        self.accelerometerZ = accelerometer.2
        self.gyroscopeX = gyroscope.0
        self.gyroscopeY = gyroscope.1
        self.gyroscopeZ = gyroscope.2
    }
    
    func toString() -> String {
        return "acc_x:" + accelerometerX.toString() + " ; " +
        "acc_y:" + accelerometerY.toString() + " ; " +
        "acc_z:" + accelerometerZ.toString() +
        "gyro_x:" + gyroscopeX.toString() + " ; " +
        "gyro_y:" + gyroscopeY.toString() + " ; " +
        "gyro_z:" + gyroscopeZ.toString()
    }
}
