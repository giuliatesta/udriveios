//
//  File.swift
//  udriveios
//
//  Created by Giulia Testa on 26/04/23.
//

import Foundation
import SwiftUI
 
struct HomePage: View {
    var body: some View {
        NavigationView {
            Text("Ciao")
                .navigationTitle("uDrive")
                .toolbar(.visible)
        }
        
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
