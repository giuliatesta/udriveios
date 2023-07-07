//
//  File.swift
//  udriveios
//
//  Created by Giulia Testa on 26/04/23.
//

import Foundation
import SwiftUI
import CoreMotion

let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
let utils = Utils()

struct HomePage: View {
    @State private var showAlert = false
    //Con una variabile per valore di accelerometro funzionava
    var motionManager = CMMotionManager()
    @State private var accelerometerValues = SensorValues(sensorValues: (0,0,0))
    @State private var gyroscopeValues = SensorValues(sensorValues: (0,0,0))
    
    @State var direction : Direction = Direction.NONE
    var threshold : Double = 100
    @State var thresholdSurpassed = false
    var classifier = Classifier()
    
    @State private var showStopAlert = false

    var body: some View {
        NavigationView {
            VStack{
                VStack{

                    Image(systemName: "timer")
                        .fillImageModifier()
                        .padding([.horizontal], 150)
                    
                }.padding(200)
                
                Button("STOP"){
                    showStopAlert = true
                }.alert(isPresented: $showStopAlert){
                    Alert(
                        title: Text("Sei sicuro di voler terminare la guida?"),
                        primaryButton: Alert.Button.default(Text("OK")),
                        secondaryButton: Alert.Button.destructive(Text("Annulla"))
                    )
                }
                
                Text(accelerometerValues.getValuesToString())
                
                NavigationLink(destination: AlertView(direction: $direction),
                    isActive: $thresholdSurpassed
                ){
                    EmptyView()
                }
            }
            .navigationTitle("uDrive")
            .padding(10)
        }
        .navigationBarBackButtonHidden(true)
        .viewDidLoadModifier(){
            print("LOADED VIEW")
            motionManager.startAccelerometerUpdates()
            motionManager.accelerometerUpdateInterval = 1 // seconds
        }
        .onReceive(timer) { input in
            if motionManager.isAccelerometerActive {
                motionManager.startAccelerometerUpdates(to: OperationQueue.main) { data,error in
                    self.accelerometerValues.setValues((data?.acceleration.x ?? 0,
                                                        data?.acceleration.y ?? 0,
                                                        data?.acceleration.z ?? 0))
                    print(accelerometerValues.getValuesToString())
                    thresholdSurpassed = classifier.classify(values: accelerometerValues, threshold: threshold)
                }
            }
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
