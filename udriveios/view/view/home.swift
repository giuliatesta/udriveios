import Foundation
import SwiftUI

let utils = Utils()


/* View that shows a timer indicating for how long the safe driving behaviour is mantained.
   It's also possible to terminate the driving session. */

struct HomePage: View {
    @State var direction : Direction = Direction.NONE                   //Starting direction is initialized at NONE
    @State var duration : Int = 0
    
    @State private var endDrive = false
    @State var showAlert = false;
    @State private var showStopAlert = false;
    
    var classifier = Classifier()                                       //Classifier object used to classify the current driving behaviour based on the sensorValues attribute
    
    @ObservedObject var sensorValuesManager = SensorValuesManager();    //Observable object used to detect any changes in accelerometer or gyroscope values of the device
    
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
                            sensorValuesManager.stopUpdates();                          //Stops updating accelerometer and gyroscope values
                            LocationManager.getInstance().stopRecordingLocations()      //Stops recording location
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
        //This method detects any changes to the @ObservedObject sensorValuesManager.sensorValues
        //in order to update the view to show the AlertView if needed
        .onChange(of: sensorValuesManager.sensorValues, perform: { newValue in
            print(sensorValuesManager.sensorValues.toString())
            classifier.insert(sensorValues: sensorValuesManager.sensorValues);      //Adds the new values in the classifier's sliding window
            let classLabel = classifier.classify();                                 //Behaviour classification
            direction = Direction.getDirection(label: classLabel)
            showAlert = Direction.isDangerous(label: classLabel);
        })
        .navigationBarBackButtonHidden(true)
        .viewDidLoadModifier() {
            sensorValuesManager.startUpdates();
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
