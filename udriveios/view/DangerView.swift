import SwiftUI
import AudioToolbox
import AVFoundation

let blinkTimer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()

let soundUrl = URL(string: "/System/Library/Audio/UISounds/alarm.caf")


/* View that shows the Direction of the dangerous behaviour along with a
 timer indicating for how long the dangerous behaviour is mantained */
struct DangerView : View {
    @Binding var direction: Direction
    @State private var _directionToBeSaved : Direction?
    @State var backgroundColor = Color.red
    @State private var showHome = false
    
    let soundPlayer: SoundPlayer = SoundPlayer.getInstance();
    
    @State var dangerousLocationManager = DangerousLocationManager.getInstance();
    
    @State var timerHandler : TimerHandler?;
    @State var duration : Int = 0;
   

    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                VStack(alignment: .center) {
                    HStack(alignment: .center) {
                        // A different icon is shown based on the direction received by the HomeView
                        switch direction {
                        case .BREAK:
                            Image(systemName: "arrow.down")
                                .fitImageModifier()
                                .padding([.horizontal], 70)
                        case .ACCELERATION:
                            Image(systemName: "arrow.up")
                                .fitImageModifier()
                                .padding([.horizontal], 70)
                        case .LEFT:
                            Image(systemName: "arrow.left")
                                .fitImageModifier()
                                .padding([.horizontal], 70)
                        case .RIGHT:
                            Image(systemName: "arrow.right")
                                .fitImageModifier()
                                .padding([.horizontal], 70)
                        case .NONE:
                            EmptyView()
                        }
                    }
                    .frame(height: 300)
                    .padding([.top], 75)
                    VStack {
                        TimerView(duration: $duration)
                            .bold()
                            .font(.title)
                        Text("ATTENZIONE!")
                            .font(.largeTitle)
                            .bold()
                            .monospacedDigit()
                            .padding([.top], 5)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding([.bottom], 50)
                }
            }
            .background(backgroundColor)
        }
        .navigationBarBackButtonHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onReceive(blinkTimer) { input in
            if backgroundColor == .red {
                backgroundColor = .white
            } else {
                backgroundColor = .red
            }
        }
        .onAppear {
            soundPlayer.initSoundPlayer(soundUrl: soundUrl)
            soundPlayer.play()      //Starts playing sound
            
            CoreDataManager.getInstance().context = viewContext
            dangerousLocationManager.startRecordingDangerousLocations();
            
            timerHandler = TimerHandler(duration: $duration)
            timerHandler!.startTimer()      // it is not nil since it has just been initilized
            
            _directionToBeSaved = direction
        }
        .onDisappear {
            soundPlayer.stop()
            dangerousLocationManager.stopRecordingDangerousLocations(direction: _directionToBeSaved!, duration: timerHandler?.getDuration() ?? 0)
            TimeIntervalManager.getInstance().saveTimeInterval(duration: duration, isDangerous:true)
            
            timerHandler?.stopTimer()
        }
    }
}


struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        DangerView(direction: .constant(Direction.ACCELERATION))
    }
}

