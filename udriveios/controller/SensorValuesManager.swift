import Foundation
import CoreMotion

let UPDATE_INTERVAL : Double = 1.0

class SensorValuesManager : ObservableObject {
    private let motionManager = CMMotionManager()
    
    @Published var sensorValues: SensorValues = SensorValues(accelerometerX: 0,accelerometerY: 0,accelerometerZ: 0,gyroscopeX: 0,gyroscopeY: 0,gyroscopeZ: 0);
    
    func startUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = UPDATE_INTERVAL
            motionManager.startDeviceMotionUpdates(to: .main) { (motionData, error) in
                if let data = motionData {
                    let accelerometerData = data.userAcceleration
                    let gyroscopeData = data.rotationRate
                    self.sensorValues = SensorValues(accelerometer: accelerometerData, gyroscope: gyroscopeData)
                }
            }
        }
    }
    
    func stopUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
}

