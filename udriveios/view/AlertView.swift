//
//  AlertView.swift
//  udriveios
//
//  Created by Sara Regali on 29/05/23.
//

import SwiftUI
import AudioToolbox
import AVFoundation

let blinkTimer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()

let soundUrl = URL(string: "/System/Library/Audio/UISounds/alarm.caf")

struct AlertView : View{
    @Binding var direction: Direction
    //var direction: Direction
    @State var backgroundColor = Color.red
    @State private var showHome = false
    
    let soundPlayer: SoundPlayer = SoundPlayer(soundUrl: soundUrl, silenceDuration: 3)

    var body: some View {
        NavigationView {
            VStack{
                ZStack(alignment: .center){
                    VStack{
                        switch direction {
                            case .BACKWARD:
                                Image(systemName: "arrow.down")
                                    .fitImageModifier()
                                    .padding([.horizontal], 70)
                            case .FORWARD:
                                Image(systemName: "arrow.up")
                                    .fitImageModifier()
                                    .padding([.horizontal], 70)
                            case .LEFT:
                                Image(systemName: "arrow.left")
                                    .fitImageModifier()
                                    .padding([.horizontal], 70)
                            case .RIGHT:
                                Image(systemName: "arrow.right")
                                    .fitImageModifier()
                                    .padding([.horizontal], 70)
                            case .NONE:
                                Image(systemName: "arrow.up")
                                    .fitImageModifier()
                                    .padding([.horizontal], 70)
                        }
                    }.frame(height: 300)
                    VStack{
                        TimerView().bold()
                        Text("CAREFUL!").font(.largeTitle).bold().monospacedDigit()
                    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                        .padding([.bottom], 50)
                    }
                }
                .background(backgroundColor)
            }
            .navigationBarBackButtonHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onReceive(blinkTimer) { input in
                if backgroundColor == .red {
                    backgroundColor = .white
                }else{
                    backgroundColor = .red
                }
            }
            .onAppear {
                soundPlayer.play()
            }
            .onDisappear {
                soundPlayer.stop()
            }
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(direction: .constant(Direction.NONE))
    }
}
