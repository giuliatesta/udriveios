//
//  CMMotionManager.swift
//  udriveios
//
//  Created by Sara Regali on 08/05/23.
//

import Foundation
import CoreMotion

//The instance must be singleton
class MyCMMotionManager : CMMotionManager {
    static let instance = CMMotionManager()

    //Private initializator, only this class can create instances of itself
    private override init(){
        
    }
    
    
}

