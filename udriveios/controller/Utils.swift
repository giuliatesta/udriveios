//
//  Utils.swift
//  udriveios
//
//  Created by Sara Regali on 26/05/23.
//

import Foundation
import UIKit.UIImage

class Utils{
    
    public func getValueToString(value: Double) -> String {
        return "x:" + value.toString() + " ; "
    }
    
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func toString() -> String {
        return "\(self.rounded(toPlaces :3))"
    }
}


/**
 Enum class representing the car's directions
 */
enum Direction{
    /**
     * BREAK: sudden break
     * ACCELERATION: sudden acceleration
     * LEFT: sudden left turn
     * RIGHT: sudden right turn
     * NONE:  no sudden movement is being performed
     */
    case BREAK, ACCELERATION, LEFT, RIGHT, NONE

    func getInt() -> Int {
        switch self {
        case .ACCELERATION:
            return 0;
        case .RIGHT:
            return 1;
        case .LEFT:
            return 2;
        case .BREAK:
            return 3;
        case .NONE:
            return 4;
        }
    }
}
