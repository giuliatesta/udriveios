import SwiftUI

/* View showing a timer (in seconds) to be used in Home and Alert Views*/
struct TimerView: View {
    @State private var startTime =  Date()  // seconds already passed from the start of TimerView
    @Binding var duration : Int
    
    var body: some View {
        Text(duration.formatted(allowedUnits: [.hour, .minute, .second]) ?? "")
            .font(.largeTitle)
    }
}

extension Date {
    var durationToNow: Int? {
        return Calendar.current
            .dateComponents([.second], from: self, to: Date())
            .second
    }
}

extension Int {
    func formatted(allowedUnits: NSCalendar.Unit = [.hour, .minute]) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = allowedUnits
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: DateComponents(second: self))
    }
}
