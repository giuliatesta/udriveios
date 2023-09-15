import Foundation
import SwiftUI

let utils = Utils()

var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()


/* View that shows a timer indicating for how long the safe driving behaviour is mantained.
   It's also possible to terminate the driving session. */
struct HomeView: View {
    @State private var endDrive = false
    @State var direction : Direction = Direction.NONE    // starting direction is initialized at NONE
    
    @State var showAlert = false;
    @State private var showStopAlert = false;
    
    // It classifies the current driving behaviour based on the sensorValues attribute
    var classifier = Classifier()
    
    // It detects any changes in accelerometer or gyroscope values of the device
    @ObservedObject var sensorValuesManager = SensorValuesManager();
    
    @State var timerHandler : TimerHandler?;
    @State var duration : Int = 0;
    
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationView {
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
                            sensorValuesManager.stopUpdates();       // Stops updating accelerometer and gyroscope values
                            LocationManager.getInstance().stopRecordingLocations()      //Stops recording location
                            TimeIntervalManager.getInstance().saveTimeInterval(duration: timerHandler?.getDuration() ?? 0, isDangerous: false)
                            timerHandler?.stopTimer()
                        }),
                        secondaryButton: Alert.Button.destructive(Text("Annulla"))
                    )
                }
                NavigationLink(destination: AlertView(direction: $direction), isActive: $showAlert)
                {
                    EmptyView()
                }
                NavigationLink(destination: ReportView(), isActive: $endDrive)
                {
                    EmptyView()
                }
            }
            .navigationTitle("uDrive")
           
        }
        // This method detects any changes to the @ObservedObject sensorValuesManager.sensorValues
        // in order to update the view to show the AlertView if needed
        .onChange(of: sensorValuesManager.sensorValues, perform: { newValue in
            print(sensorValuesManager.sensorValues.toString())
            
            // Adds the new values in the classifier's sliding window
            classifier.insert(sensorValues: sensorValuesManager.sensorValues);
            let classLabel = classifier.classify();                 // behaviour classification
            direction = Direction.getDirection(label: classLabel)
            showAlert = Direction.isDangerous(label: classLabel);
        })
        .onChange(of: showAlert, perform: { newValue in
            if(showAlert) {
                TimeIntervalManager.getInstance().saveTimeInterval(
                    duration: timerHandler?.getDuration() ?? 0,
                    isDangerous: false)
                timerHandler?.stopTimer()  // reset timer counting safe time
            } else {
                timerHandler?.restartTimer()
            }
        })
        .onAppear() {
            timerHandler = TimerHandler(duration: $duration)
            timerHandler!.startTimer()
        }

        .navigationBarBackButtonHidden(true)
        .viewDidLoadModifier() {
            sensorValuesManager.startUpdates();
            
            CoreDataManager.getInstance().context = viewContext
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
