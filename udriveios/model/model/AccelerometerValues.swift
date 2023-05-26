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
    
    let motion = CMMotionManager.init()
    var timer = Timer()
    @State var accelerometerValues : (Double, Double, Double) = (0.0,0.0,0.0)
    
    func startAccelerometers() {
        // Make sure the accelerometer hardware is available.
        if self.motion.isDeviceMotionAvailable {
            self.motion.accelerometerUpdateInterval = 1.0 / 60.0  // 60 Hz
            self.motion.startAccelerometerUpdates()
            
            // Configure a timer to fetch the data.
            self.timer = Timer(fire: Date(), interval: (1.0/60.0),
                               repeats: true, block: { (timer) in
                // Get the accelerometer data.
                if let data = self.motion.accelerometerData {
                    let x = data.acceleration.x
                    let y = data.acceleration.y
                    let z = data.acceleration.z
                    
                    self.accelerometerValues = ((Double(x)),
                                                (Double(y)),
                                                (Double(z)))
                    // Use the accelerometer data in your app.
                }
            })
            
            // Add the timer to the current run loop.
            RunLoop.current.add(self.timer, forMode: .default)
        }else{
            print("Nessun accelerometro trovato")
        }
    }
    
    func getValuesToString() -> String {
        return "x:" + accelerometerValues.0.toString() + " ; " +
                "y:" + accelerometerValues.1.toString() + " ; " +
                "z:" + accelerometerValues.2.toString()
    }
}