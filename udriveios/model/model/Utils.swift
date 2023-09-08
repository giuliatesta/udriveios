import Foundation
import UIKit.UIImage

class Utils {
    
    static func getValueToString(value: Double) -> String {
        return "x:" + value.toString() + " ; "
    }
    
    static func getFormattedTime(duration: Int64) -> String {
        var formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: TimeInterval(duration)) ?? ""
        // return "\(hours):\(minutes):\(seconds)";
        
        
    }

}



extension Double {
    // Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func toString() -> String {
        return "\(self.rounded(toPlaces :3))"
    }
}



