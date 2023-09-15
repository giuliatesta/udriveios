import Foundation
import SwiftUI

/* View that shows a timer indicating for how long the safe driving behaviour is mantained.
   It's also possible to terminate the driving session. */
struct SafeView: View {
    @State private var endDrive = false
    @State private var showStopAlert = false;
    
    @State var timerHandler : TimerHandler?;
    @State var duration : Int = 0;
    
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    ClockView(duration: $duration)
                    TimerView(duration: $duration)
                        .padding([.top],30)
                }
                Button(action: {showStopAlert = true}) {
                    HStack {
                        Image(systemName: "stop.fill")
                        Text("TERMINA")
                            .font(.title)
                    }
                }
                .buttonStyle(CustomButtonStyle())
                .alert(isPresented: $showStopAlert) {
                    Alert (
                        title: Text("Sei sicuro di voler terminare la guida?"),
                        primaryButton: Alert.Button.default(Text("Ok"), action: {
                            endDrive = true
                            SensorValuesManager().stopUpdates();       // Stops updating accelerometer and gyroscope values
                            LocationManager.getInstance().stopRecordingLocations()      //Stops recording location
                            TimeIntervalManager.getInstance().saveTimeInterval(duration: timerHandler?.getDuration() ?? 0, isDangerous: false)
                            timerHandler?.stopTimer()
                        }),
                        secondaryButton: Alert.Button.destructive(Text("Annulla"))
                    )
                }
            }
        }
        .onAppear() {
            timerHandler = TimerHandler(duration: $duration)
            timerHandler!.startTimer()
        }
        .navigationDestination(isPresented: $endDrive, destination: {
            ReportView()
        })
        .navigationBarBackButtonHidden(true)
    }
}

struct SafeView_Previews: PreviewProvider {
    static var previews: some View {
        SafeView()
    }
}
