//
//  ContentView.swift
//  udriveios
//
//  Created by Giulia Testa on 26/04/23.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Text("uDrive")
                .fontWeight(Font.Weight.semibold)
                .font(.system(size: 40))
            Image("car-steering-wheel-svgrepo-com")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(40)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)

    }
    
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
            
    }
}
