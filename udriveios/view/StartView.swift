//
//  StartView.swift
//  udriveios
//
//  Created by Sara Regali on 09/06/23.
//

import SwiftUI

struct StartView: View {
    var body: some View {
        
        NavigationView{
            VStack{
                Text("Rotate your phone vertically").font(fontSystem)
                GifImage("rotate_phone").frame(width: 150, height: 150, alignment: .center)
                NavigationLink(destination: HomePage(), label: {
                    Text("Start Driving!").font(.largeTitle)
                })
                .padding()
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
    
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
    
    
}
