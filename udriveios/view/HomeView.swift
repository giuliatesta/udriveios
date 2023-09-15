import SwiftUI

struct HomeView : View {
    @State var danger : Bool = false
    @State var direction : Direction = Direction.NONE    // starting direction is initialized at NONE
    
    // It classifies the current driving behaviour based on the sensorValues attribute
    var classifier = Classifier()
    
    // It detects any changes in accelerometer or gyroscope values of the device
    @ObservedObject var sensorValuesManager = SensorValuesManager.getInstance();
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationStack {
            VStack {
                if (danger) {
                    DangerView(direction: $direction)
                } else {
                    SafeView()
                        .transition(.slide)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: danger)
        }
        // This method detects any changes to the @ObservedObject sensorValuesManager.sensorValues
        // in order to update the view to show the AlertView if needed
        .onChange(of: sensorValuesManager.sensorValues, perform: { newValue in
            print(sensorValuesManager.sensorValues.toString())
            
            // Adds the new values in the classifier's sliding window
            classifier.insert(sensorValues: sensorValuesManager.sensorValues);
            let classLabel = classifier.classify();                 // behaviour classification
            direction = Direction.getDirection(label: classLabel)
            danger = Direction.isDangerous(label: classLabel);
        })
        .navigationTitle("uDrive")
        .navigationBarBackButtonHidden(true)
        .viewDidLoadModifier() {
            sensorValuesManager.startUpdates();
            
            CoreDataManager.getInstance().context = viewContext
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
