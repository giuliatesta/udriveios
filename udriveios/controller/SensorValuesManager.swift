import Foundation
import CoreMotion

let UPDATE_INTERVAL : Double = 0.5

/* Class used to detect the changes in the device's motion updates (accelerometer and gyroscope values) */
class SensorValuesManager : ObservableObject {
    
    static private var instance : SensorValuesManager?;
    
    static func getInstance() -> SensorValuesManager {
        if(instance == nil) {
            instance = SensorValuesManager();
        }
        return instance!;
    }
    
    private let motionManager = CMMotionManager()
    
    @Published var sensorValues: SensorValues = SensorValues(gyroscopeX: 0, gyroscopeY: 0, gyroscopeZ: 0, accelerometerX: 0, accelerometerY: 0, accelerometerZ: 0);
    
    func startUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = UPDATE_INTERVAL
            motionManager.startDeviceMotionUpdates(to: .main) { (motionData, error) in
                if let data = motionData {
                    let accelerometerData = data.userAcceleration
                    let gyroscopeData = data.rotationRate
                    self.sensorValues = SensorValues(gyroscope: gyroscopeData, accelerometer: accelerometerData)
                }
            }
        }
    }
    
    func stopUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
}

