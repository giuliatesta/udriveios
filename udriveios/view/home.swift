import Foundation
import SwiftUI
import CoreMotion

let sensorFrequencyTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
let utils = Utils()

struct HomePage: View {
    @State private var endDrive = false
    //Con una variabile per valore di accelerometro funzionava
    var motionManager = CMMotionManager()
    @State var direction : Direction = Direction.NONE
    @State var duration : Int = 0; 
    @State var showAlert = false
    var classifier = Classifier()
    
    @State private var showStopAlert = false

    var body: some View {
        NavigationView {
            VStack{
                VStack{
                    Image(systemName: "timer")
                        .fillImageModifier()
                        .padding([.horizontal], 150)
                        .frame(width: 500,height: 300)
                    TimerView(duration: $duration).padding([.top],30)
                }.frame(height: 500)
                
                Button(action: {showStopAlert = true}){
                    HStack{
                        Image(systemName: "stop.fill")
                        Text("STOP")
                    }
                }
                .buttonStyle(.borderedProminent)
                .alert(isPresented: $showStopAlert){
                    Alert(
                        title: Text("Sei sicuro di voler terminare la guida?"),
                        primaryButton: Alert.Button.default(Text("OK"), action: {
                            endDrive = true
                            LocationManager.getInstance().stopRecordingLocations()
                            // stops the timer and the classifier
                            sensorFrequencyTimer.upstream.connect().cancel()
                            
                            // TODO save duration in CoreData
                        }),
                        secondaryButton: Alert.Button.destructive(Text("Annulla"))
                    )
                }
                
                NavigationLink(destination: ReportView(),
                    isActive: $endDrive
                ){
                    EmptyView()
                }
                
                // TODO save safe duration 
                NavigationLink(destination: AlertView(direction: $direction),
                    isActive: $showAlert
                ){
                    EmptyView()
                }
            }
            .navigationTitle("uDrive")
            .padding(10)
        }
        .navigationBarBackButtonHidden(true)
        .viewDidLoadModifier(){
            motionManager.startAccelerometerUpdates()
            motionManager.startGyroUpdates()
            // Updates are expressed in seconds
            motionManager.accelerometerUpdateInterval = 1
            motionManager.gyroUpdateInterval = 1

        }
        .onReceive(sensorFrequencyTimer) { input in
            var accelerometer : (Double, Double, Double) = (0,0,0);
            if motionManager.isAccelerometerActive {
                motionManager.startAccelerometerUpdates(to: OperationQueue.main) {
                    data, error in
                    accelerometer = ((data?.acceleration.x ?? 0,
                                      data?.acceleration.y ?? 0,
                                      data?.acceleration.z ?? 0))
                 }
            }
            var gyroscope : (Double, Double, Double) = (0,0,0);
            if motionManager.isGyroActive {
                motionManager.startGyroUpdates(to: OperationQueue.main) {
                    data, error in
                    gyroscope = ((data?.rotationRate.x ?? 0,
                                  data?.rotationRate.y ?? 0,
                                  data?.rotationRate.z ?? 0))
                    }
            }
            classifier.insert(sensorValues: SensorValues(accelerometer: accelerometer, gyroscope: gyroscope));
            var classLabel = classifier.classify();
            showAlert = Direction.isDangerous(label: classLabel);
            direction = Direction.getDirection(label: classLabel)
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
