//
//  Timer.swift
//  udriveios
//
//  Created by Giulia Testa on 08/07/23.
//

import SwiftUI

//Timer view to be used in Home and Alert Views
struct TimerView: View {
    @State var isTimerRunning = false
    @State private var startTime =  Date()
    @State var duration: Int = 0
    @State private var timerString = "00:00:00"
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {

        Text(self.duration.formatted(allowedUnits: [.hour, .minute, .second]) ?? "")
            .font(fontSystem)
            .onReceive(self.timer) { _ in
                self.duration = startTime.durationToNow ?? 0
            }
            .onAppear() {
                // no need for UI updates at startup
                self.stopTimer()
            }
    }
    
    func stopTimer() {
        if(isTimerRunning){
            self.timer.upstream.connect().cancel()
        }
    }
    
    func startTimer() {
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
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
