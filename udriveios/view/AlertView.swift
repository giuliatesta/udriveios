//
//  AlertView.swift
//  udriveios
//
//  Created by Sara Regali on 29/05/23.
//

import SwiftUI

let blinkTimer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()

struct AlertView : View{
    //@Binding var direction: Direction
    var direction: Direction
    @State var backgroundColor = Color.red
    @State private var showHome = false

    var body: some View {
        NavigationView {
            VStack{
                ZStack(alignment: .center){
                    switch direction {
                    case .BACKWARD:
                        Image(systemName: "arrow.up")
                            .fitImageModifier()
                    case .FORWARD:
                        Image(systemName: "arrow.up")
                            .fitImageModifier()
                    case .LEFT:
                        Image(systemName: "arrow.up")
                            .fitImageModifier()
                    case .RIGHT:
                        Image(systemName: "arrow.up")
                            .fitImageModifier()
                    case .NONE:
                        Image(systemName: "arrow.up")
                            .fitImageModifier()
                            .padding([.horizontal], 70)
                    }
                    VStack{
                        Text("XX%").font(.largeTitle).bold().monospacedDigit()
                        Text("CAREFUL!").font(.largeTitle).bold().monospacedDigit()
                    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                        .padding([.bottom], 50)
                    }
                }
                .background(backgroundColor)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onReceive(blinkTimer) { input in
                if backgroundColor == .red {
                    backgroundColor = .white
                }else{
                    backgroundColor = .red
                }
            }
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(direction: Direction.NONE)
    }
}
