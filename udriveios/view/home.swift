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
    
    var motionManager = CMMotionManager()
    @State private var accelerometerX : Double = 0
    @State private var accelerometerY : Double = 0
    @State private var accelerometerZ : Double = 0
    @State private var riskyBehaviour = true
    
    @State var direction = Direction.NONE
    
    var arrowRightColour: Color{
        if self.accelerometerX > 0.0{
            return .blue
        }else{
            return .black
        }
    }
    var arrowLeftColour: Color{
        if self.accelerometerX < 0.0{
            return .blue
        }else{
            return .black
        }
    }
    var arrowTopColour: Color{
        if self.accelerometerZ < 0.0{
            return .blue
        }else{
            return .black
        }
    }
    var arrowBottomColour: Color{
        if self.accelerometerZ > 0.0{
            return .blue
        }else{
            return .black
        }
    }
    
    var body: some View {
        NavigationView {
            VStack{
                VStack{
                    Image(systemName: "arrow.up")
                        .fillImageModifier()
                        .foregroundColor(arrowTopColour)
                        .padding([.horizontal], 150)
                    HStack{
                        Image(systemName: "arrow.left")
                            .fillImageModifier()
                            .foregroundColor(arrowLeftColour)
                        Image(systemName: "triangle")
                            .fillImageModifier()
                        Image(systemName: "arrow.right")
                            .fillImageModifier()
                            .foregroundColor(arrowRightColour)
                    }.padding(20)
                    Image(systemName: "arrow.down")
                        .fillImageModifier()
                        .foregroundColor(arrowBottomColour)
                        .padding([.horizontal], 150)
                }.padding(100)
                
                Text(utils.getValueToString(value: self.accelerometerX)
                     + utils.getValueToString(value: self.accelerometerY)
                     + utils.getValueToString(value: self.accelerometerZ))
                .navigationTitle("uDrive")
                .toolbar(.visible)
                Button(action: {
                    showAlert.toggle()
                }) {
                    Text("ShowAlert").font(.largeTitle).monospacedDigit().foregroundColor(.blue)
                }
            }
            /*.alert(isPresented: $riskyBehaviour) {
                Alert(title: Text("Attenzione, pericolo"))
            }*/
        }
        .viewDidLoadModifier(){
            motionManager.startAccelerometerUpdates()
            motionManager.accelerometerUpdateInterval = 1 // seconds
        }
        .onReceive(timer) { input in
            if motionManager.isAccelerometerActive {
                motionManager.startAccelerometerUpdates(to: OperationQueue.main) { data,error in
                    accelerometerX = data?.acceleration.x ?? 0
                    accelerometerY = data?.acceleration.y ?? 0
                    accelerometerZ = data?.acceleration.z ?? 0
                    print("Acceleration values")
                    print(data?.acceleration.x ?? 0)
                    print(data?.acceleration.y ?? 0)
                    print(data?.acceleration.z ?? 0)
                }
            }
        }
        
        //NavigationLink(destination: AlertView(direction: $direction)){
        //    EmptyView()
        //}
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
