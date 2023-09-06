import SwiftUI
import AudioToolbox
import AVFoundation

let blinkTimer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()

let soundUrl = URL(string: "/System/Library/Audio/UISounds/alarm.caf")

struct AlertView : View{
    @Binding var direction: Direction
    @State var duration: Int = 0;
    
    @State var backgroundColor = Color.red
    @State private var showHome = false
    
    let soundPlayer: SoundPlayer = SoundPlayer(soundUrl: soundUrl, silenceDuration: 3)
    
    @State var dangerousLocationManager = DangerousLocationManager.getInstance();

    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationView {
            VStack{
                ZStack(alignment: .center){
                    VStack{
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
                                Image(systemName: "arrow.up")
                                    .fitImageModifier()
                                    .padding([.horizontal], 70)
                        }
                    }.frame(height: 300)
                    VStack{
                        TimerView(duration: $duration).bold()
                        Text("CAREFUL!").font(.largeTitle).bold().monospacedDigit()
                    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
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
                }else{
                    backgroundColor = .red
                }
            }
            .onAppear {
                
                soundPlayer.play()
                
                CoreDataManager.getInstance().context = viewContext
                dangerousLocationManager.startRecordingDangerousLocations();
                
            }
            // TODO check if it works
            .onDisappear {
                soundPlayer.stop()
                dangerousLocationManager.stopRecordingDangerousLocations(direction: direction, duration: duration)
                TimeIntervalManager.getInstance().saveTimeInterval(duration: duration, isDangerous: true)
            }
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(direction: .constant(Direction.NONE))
    }
}
