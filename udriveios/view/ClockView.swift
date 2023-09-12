import SwiftUI
import Combine


struct Clock: Shape {
    let timeInterval: TimeInterval
    let tickerScale: CGFloat = 0.8
    
    var angleMultiplier: CGFloat {
        return CGFloat(self.timeInterval.remainder(dividingBy: 60)) / 60
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let length = rect.width / 2
        let center = CGPoint(x: rect.midX, y: rect.midY)

        path.move(to: center)
        let angle = CGFloat.pi / 2 - .pi * 2 * angleMultiplier
        path.addLine(to: CGPoint(x: rect.midX + cos(angle) * length * tickerScale,
                                 y: rect.midY - sin(angle) * length * tickerScale))
        return path
    }
}

struct ClockView: View {
    @State private var startTime =  Date()  // seconds already passed from the start of Timer
    @State var duration: Int = 0;

    var body: some View {
        ZStack {
                 ForEach(0..<60) { tick in
                     self.tick(at: tick)
                 }
                 GeometryReader { geometry in
                     ZStack {
                         HStack {
                             Text("9")
                             Spacer()
                             Text("3")
                             EmptyView()
                         }
                         .padding()
                         VStack {
                             EmptyView()
                             Text("12")
                             Spacer()
                             Text("6")
                             EmptyView()
                         }
                         .padding()
                        
                     }.frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                 }
                
            Clock(timeInterval: TimeInterval(duration))
                 .stroke(Color.red, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                 .rotationEffect(Angle.degrees(360/60))
                 
            }
            .frame(width: 200, height: 200, alignment: .center)
            .onReceive(timer) { _ in
                duration = startTime.durationToNow ?? 0
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
    
    
    func tick(at tick: Int) -> some View {
               VStack {
                   Rectangle()
                       .fill(Color.primary)
                       .opacity(tick % 5 == 0 ? 1 : 0.4)
                       .frame(width: 2, height: tick % 5 == 0 ? 15 : 7)
                   Spacer()
           }.rotationEffect(Angle.degrees(Double(tick)/(60) * 360))
    }
}

struct ClockView_Previews: PreviewProvider {
   static var previews: some View {
       ClockView()
   }
}
