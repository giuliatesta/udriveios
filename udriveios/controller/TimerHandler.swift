import SwiftUI
import Foundation

class TimerHandler {
    @Binding var duration : Int;
    private var timer : Timer?;
    
    init(duration: Binding<Int>) {
        _duration = duration
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(1), repeats: true) {_ in
            self.tick()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    func restartTimer() {
        startTimer()
        duration = 0
    }
    
    func tick() {
        duration += 1
    }
    
    func getDuration() -> Int {
        return duration
    }
    
}
