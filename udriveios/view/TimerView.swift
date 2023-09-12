import SwiftUI

/* View showing a timer (in seconds) to be used in Home and Alert Views*/
struct TimerView: View {
    @State private var startTime =  Date()  // seconds already passed from the start of TimerView
    @Binding var duration: Int;
    @State private var timerString = "00:00:00"

    var body: some View {
        Text(self.duration.formatted(allowedUnits: [.hour, .minute, .second]) ?? "")
            .font(fontSystem)
            .onReceive(timer) { _ in
                self.duration = startTime.durationToNow ?? 0
            }
            .onAppear() {
                // reset timer
                startTime = Date();
            }
            .onDisappear() {
                // reset timer
                startTime = Date();
            }
    }
    
    func stopTimer() {
        timer.upstream.connect().cancel()
    }
        
    func getDuration() -> Int {
        return self.duration;
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
