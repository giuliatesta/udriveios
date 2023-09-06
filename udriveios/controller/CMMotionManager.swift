import Foundation
import CoreMotion

//The instance must be singleton
class MyCMMotionManager : CMMotionManager {
    static let instance = CMMotionManager()

    //Private initializator, only this class can create instances of itself
    private override init(){
        
    }
        
}

