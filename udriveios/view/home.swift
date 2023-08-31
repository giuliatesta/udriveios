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
    @State private var endDrive = false
    //Con una variabile per valore di accelerometro funzionava
    var motionManager = CMMotionManager()
    @State private var accelerometerValues = SensorValues(sensorValues: (0,0,0))
    @State private var gyroscopeValues = SensorValues(sensorValues: (0,0,0))
    
    @State var direction : Direction = Direction.LEFT
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
                        .frame(width: 500,height: 300)
                    TimerView().padding([.top],30)
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
                            LocationManager.getInstance().stopRecordingPositions()
                        }),
                        secondaryButton: Alert.Button.destructive(Text("Annulla"))
                    )
                }
                
                NavigationLink(destination: ReportView(),
                    isActive: $endDrive
                ){
                    EmptyView()
                }
                
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
            motionManager.startAccelerometerUpdates()
            motionManager.startGyroUpdates()
            // Updates are expressed in seconds
            motionManager.accelerometerUpdateInterval = 1
            motionManager.gyroUpdateInterval = 1

        }
        .onReceive(timer) { input in
            if motionManager.isAccelerometerActive {
                motionManager.startAccelerometerUpdates(to: OperationQueue.main) { data,error in
                    self.accelerometerValues.sensorValues = ((data?.acceleration.x ?? 0,
                                                        data?.acceleration.y ?? 0,
                                                        data?.acceleration.z ?? 0))
                    //print("ACC:" + accelerometerValues.getValuesToString())
                }
            }
            
            if motionManager.isGyroActive{
                motionManager.startGyroUpdates(to: OperationQueue.main){
                    data,error in
                    self.gyroscopeValues.sensorValues = ((data?.rotationRate.x ?? 0,
                                                            data?.rotationRate.y ?? 0,
                                                            data?.rotationRate.z ?? 0))
                        //print("GYR:" + gyroscopeValues.getValuesToString())
                }
            }
            //TODO add sliding window technique
            thresholdSurpassed = classifier.classify(values: accelerometerValues, threshold: threshold)
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
