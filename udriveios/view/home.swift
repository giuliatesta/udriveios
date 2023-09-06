import Foundation
import SwiftUI

let utils = Utils()

struct HomePage: View {
    @State private var endDrive = false
    @State var direction : Direction = Direction.NONE
    @State var duration : Int = 0;
    
    @State var showAlert = false;
    @State private var showStopAlert = false;
    
    var classifier = Classifier()
    
    @ObservedObject var sensorValuesManager = SensorValuesManager();
    
    @Environment(\.managedObjectContext) private var viewContext

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
                            sensorValuesManager.stopUpdates();
                            LocationManager.getInstance().stopRecordingLocations()
                            
                            // TODO refactoring (onDisappear not working -> we need to find something else)
                            TimeIntervalManager.getInstance().saveTimeInterval(duration: duration, isDangerous: false)
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
        .onChange(of: sensorValuesManager.sensorValues, perform: { newValue in
            print(sensorValuesManager.sensorValues.toString())
            classifier.insert(sensorValues: sensorValuesManager.sensorValues);
            let classLabel = classifier.classify();
            direction = Direction.getDirection(label: classLabel)
            showAlert = Direction.isDangerous(label: classLabel);
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
        HomePage()
    }
}
