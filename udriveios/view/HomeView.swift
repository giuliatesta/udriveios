import Foundation
import SwiftUI

let utils = Utils()

/* View that shows a timer indicating for how long the safe driving behaviour is mantained.
   It's also possible to terminate the driving session. */
struct HomeView: View {
    @State private var endDrive = false
    @State var direction : Direction = Direction.NONE       //Starting direction is initialized at NONE
    @State var duration : Int = 0;
    
    @State var showAlert = false;
    @State private var showStopAlert = false;
    
    var classifier = Classifier()       //Classifier object used to classify the current driving behaviour based on the sensorValues attribute
    
    
    @ObservedObject var sensorValuesManager = SensorValuesManager();        //Observed object used to detect any changes in accelerometer or gyroscope values of the device
    
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationStack {
            VStack{
                VStack{
                    Image(systemName: "timer")
                        .fillImageModifier()
                        .padding([.horizontal], 150)
                        .frame(width: 500,height: 300)
                    TimerView(duration: $duration)
                        .padding([.top],30)
                }
                .frame(height: 500)

                Button(action: {showStopAlert = true}){
                    HStack{
                        Image(systemName: "stop.fill")
                        Text("TERMINA")
                    }
                }
                .buttonStyle(.borderedProminent)
                .alert(isPresented: $showStopAlert) {
                    Alert(
                        title: Text("Sei sicuro di voler terminare la guida?"),
                        primaryButton: Alert.Button.default(Text("OK"), action: {
                            endDrive = true
                            sensorValuesManager.stopUpdates();                          //Stops updating accelerometer and gyroscope values
                            LocationManager.getInstance().stopRecordingLocations()      //Stops recording location
                            
                            // TODO refactoring (onDisappear not working -> we need to find something else)
                            TimeIntervalManager.getInstance().saveTimeInterval(duration: duration, isDangerous: false)
                        }),
                        
                        secondaryButton: Alert.Button.destructive(Text("Annulla"))
                    )
                }
            }
            .navigationDestination(isPresented: $endDrive) {
                ReportView()
            }
            .navigationDestination(isPresented: $showAlert) {
                AlertView(direction: direction)
            }
            .navigationTitle("uDrive")
            .padding(10)
        }

        //This method detects any changes to the @ObservedObject sensorValuesManager.sensorValues
        //in order to update the view to show the AlertView if needed
        .onChange(of: sensorValuesManager.sensorValues, perform: { newValue in
            print(sensorValuesManager.sensorValues.toString())
            classifier.insert(sensorValues: sensorValuesManager.sensorValues);      //Adds the new values in the classifier's sliding window
            let classLabel = classifier.classify();                                 //Behaviour classification
            direction = Direction.getDirection(label: classLabel)
            showAlert = Direction.isDangerous(label: classLabel);
        })
        .onChange(of: showAlert, perform: { newValue in
            if(showAlert) {
                TimeIntervalManager.getInstance().saveTimeInterval(duration: duration, isDangerous: false)
            }
        })
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
