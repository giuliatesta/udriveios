import Foundation
import SwiftUI
import CoreMotion

/* Class that holds the accelerometer and gyroscope values. It conforms to the protocol Equatable in order to be
 used in the onChange() method of the Home view.*/
class SensorValues : Equatable {
    var gyroscopeX : Double;
    var gyroscopeY : Double;
    var gyroscopeZ : Double;
    var accelerometerX : Double;
    var accelerometerY : Double;
    var accelerometerZ : Double;
    
    init(gyroscopeX: Double, gyroscopeY: Double, gyroscopeZ: Double, accelerometerX: Double, accelerometerY: Double, accelerometerZ: Double) {
        self.accelerometerX = accelerometerX.truncate()
        self.accelerometerY = accelerometerY.truncate()
        self.accelerometerZ = accelerometerZ.truncate()
        self.gyroscopeX = gyroscopeX.truncate()
        self.gyroscopeY = gyroscopeY.truncate()
        self.gyroscopeZ = gyroscopeZ.truncate()
    }
    
    init(gyroscope: CMRotationRate?, accelerometer : CMAcceleration?) {
        self.gyroscopeX = (gyroscope?.x ?? 0.0).truncate()
        self.gyroscopeY = (gyroscope?.y ?? 0.0).truncate()
        self.gyroscopeZ = (gyroscope?.z ?? 0.0).truncate()
        self.accelerometerX = (accelerometer?.x ?? 0.0).truncate()
        self.accelerometerY = (accelerometer?.y ?? 0.0).truncate()
        self.accelerometerZ = (accelerometer?.z ?? 0.0).truncate()
    }
    
    func toString() -> String {
        return "gyro_x:" + gyroscopeX.toString() + "; " +
        "gyro_y:" + gyroscopeY.toString() + "; " +
        "gyro_z:" + gyroscopeZ.toString() + "; " +
        "acc_x:" + accelerometerX.toString() + "; " +
        "acc_y:" + accelerometerY.toString() + "; " +
        "acc_z:" + accelerometerZ.toString()
        
    }
    
    static func == (lhs: SensorValues, rhs: SensorValues) -> Bool {
        return  lhs.gyroscopeX == rhs.gyroscopeX &&
                lhs.gyroscopeY == rhs.gyroscopeY &&
                lhs.gyroscopeZ == rhs.gyroscopeZ &&
                lhs.accelerometerX == rhs.accelerometerX &&
                lhs.accelerometerY == rhs.accelerometerY &&
                lhs.accelerometerZ == rhs.accelerometerZ
                
    }
    
    static func cast(input : [[Double]]) -> [SensorValues] {
        return input.map { row in
            SensorValues(gyroscopeX: row[0], gyroscopeY: row[1], gyroscopeZ: row[2], accelerometerX: row[3], accelerometerY: row[4], accelerometerZ: row[5])
        }
    }
    
    // creating the [] operator to be used as it is used in arrayss
    subscript(index: Int) -> Double? {
        switch (index) {
        case 0:
            return gyroscopeX
        case 1:
            return gyroscopeY
        case 2:
            return gyroscopeZ
        case 3:
            return accelerometerX
        case 4:
            return accelerometerY
        case 5:
            return accelerometerZ
        default:
            return nil      // nil for indices out of range
        }
        
    }
}

extension Double {
    func truncate() -> Double {
       return self.rounded(toPlaces: 7)
    }
}

