import Foundation
import CoreMotion

/* Singleton instance of the CMMotionManager class */
class MyCMMotionManager : CMMotionManager {
    static let instance = CMMotionManager()

    //Private initializator, only this class can create instances of itself
    private override init(){
        
    }
        
}

