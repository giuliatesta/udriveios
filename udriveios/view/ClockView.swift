import SwiftUI
import Combine


struct Clock: Shape {
    let timeInterval: TimeInterval
    let tickerScale: Double = 0.7
    
    var angleMultiplier: Double {
        return (Double((self.timeInterval-1).remainder(dividingBy: 60.0)) / 60.0)
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let length = rect.width / 2
        let center = CGPoint(x: rect.midX, y: rect.midY)
        path.move(to: center)
        let angle = Double.pi / 2 - .pi * 2 * angleMultiplier
        path.addLine(to: CGPoint(
            x: rect.midX + cos(angle) * length * tickerScale,
            y: rect.midY - sin(angle) * length * tickerScale))
        return path
    }
}

struct ClockView: View {
    @Binding var duration: Int

    var body: some View {
        ZStack {
               ForEach(0..<60) { tick in
                     self.tick(at: tick)
                 }
                 GeometryReader { geometry in
                     ZStack {
                         HStack {
                             Text("9")
                                 .font(.title)
                             Spacer()
                             Text("3")
                                 .font(.title)
                             EmptyView()
                         }
                         .padding(25)
                         VStack {
                             EmptyView()
                             Text("12")
                                 .font(.title)
                             Spacer()
                             Text("6")
                                 .font(.title)
                             EmptyView()
                         }
                         .padding(20)
                        
                     }
                 }
                
            Clock(timeInterval: TimeInterval(duration))
                 .stroke(
                    Color.red,
                    style: StrokeStyle(
                        lineWidth: 3,
                        lineCap: .round,
                        lineJoin: .round))
                 .rotationEffect(Angle.degrees(360/60))
            }
            .frame(width: 350, height: 350, alignment: .center)
    }
    
    
    func tick(at tick: Int) -> some View {
               VStack {
                   Rectangle()
                       .fill(.blue)
                       .opacity(tick % 5 == 0 ? 1 : 0.5)
                       .frame(width: 3, height: tick % 5 == 0 ? 20 : 10)
                   Spacer()
           }.rotationEffect(Angle.degrees(Double(tick)/(60) * 360))
    }
}
