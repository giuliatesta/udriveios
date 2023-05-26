//
//  Utils.swift
//  udriveios
//
//  Created by Sara Regali on 26/05/23.
//

import Foundation

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