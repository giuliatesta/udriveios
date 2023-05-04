//
//  ContentView.swift
//  udriveios
//
//  Created by Giulia Testa on 26/04/23.
//

import SwiftUI

struct LoadingView: View {
    @State private var isRotating = 0.0
      var body: some View {
        VStack {
            Image("car-steering-wheel-svgrepo-com")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding([.horizontal], 70)
                .rotationEffect(.degrees(isRotating))
                .onAppear() {
                    withAnimation(.linear(duration: 1).speed(0.25).repeatForever(autoreverses: false)) {
                        isRotating = 360.0
                    }
                }
                .invertColorModifier()

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
}


struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
            
    }
}
