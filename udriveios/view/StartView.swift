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
            NavigationLink(destination: HomePage(), label: {
                Text("Start Driving!").font(.largeTitle)
            })
            .padding()
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
