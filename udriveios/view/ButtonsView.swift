//
//  ButtonsView.swift
//  udriveios
//
//  Created by Giulia Testa on 08/07/23.
//

import SwiftUI

struct StopButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .controlSize(.large)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}


// Create the Add to Cart button

struct ButtonsView: View {
    var body: some View {
        VStack{
            Button("Ciao"){}.buttonStyle(StopButton())
        }
    }
}

struct ButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonsView()
    }
}
