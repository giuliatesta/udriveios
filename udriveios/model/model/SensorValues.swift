import Foundation
import SwiftUI
import CoreMotion

class SensorValues : Equatable {
   
    
    var accelerometerX : Double;
    var accelerometerY : Double;
    var accelerometerZ : Double;
    var gyroscopeX : Double;
    var gyroscopeY : Double;
    var gyroscopeZ : Double;
    
    init(accelerometerX: Double, accelerometerY: Double, accelerometerZ: Double, gyroscopeX: Double, gyroscopeY: Double, gyroscopeZ: Double) {
        self.accelerometerX = accelerometerX.truncate()
        self.accelerometerY = accelerometerY.truncate()
        self.accelerometerZ = accelerometerZ.truncate()
        self.gyroscopeX = gyroscopeX.truncate()
        self.gyroscopeY = gyroscopeY.truncate()
        self.gyroscopeZ = gyroscopeZ.truncate()
    }
    
    init(accelerometer : CMAcceleration?, gyroscope: CMRotationRate?) {
        self.accelerometerX = (accelerometer?.x ?? 0.0).truncate()
        self.accelerometerY = (accelerometer?.y ?? 0.0).truncate()
        self.accelerometerZ = (accelerometer?.z ?? 0.0).truncate()
        self.gyroscopeX = (gyroscope?.x ?? 0.0).truncate()
        self.gyroscopeY = (gyroscope?.y ?? 0.0).truncate()
        self.gyroscopeZ = (gyroscope?.z ?? 0.0).truncate()
    }
    
    func toString() -> String {
        return "acc_x:" + accelerometerX.toString() + "; " +
        "acc_y:" + accelerometerY.toString() + "; " +
        "acc_z:" + accelerometerZ.toString() + "; " +
        "gyro_x:" + gyroscopeX.toString() + "; " +
        "gyro_y:" + gyroscopeY.toString() + "; " +
        "gyro_z:" + gyroscopeZ.toString()
    }
    
    static func == (lhs: SensorValues, rhs: SensorValues) -> Bool {
        return  lhs.accelerometerX == rhs.accelerometerX &&
                lhs.accelerometerY == rhs.accelerometerY &&
                lhs.accelerometerZ == rhs.accelerometerZ &&
                lhs.gyroscopeX == rhs.gyroscopeX &&
                lhs.gyroscopeY == rhs.gyroscopeY &&
                lhs.gyroscopeZ == rhs.gyroscopeZ
    }
}

extension Double {
    func truncate() -> Double {
       return self.rounded(toPlaces: 7)
    }
}
