//
//  myViewModifier.swift
//  udriveios
//
//  Created by Giulia Testa on 26/04/23.
//

import Foundation
import SwiftUI



struct MyViewModifer : ViewModifier{
    // @State private var bold = false
    func body(content: Content) -> some View {
        content.padding(10)
        /*content.toolbar {
            ToolbarItemGroup {
                Toggle(isOn: $bold) {
                    Image(systemName: "bold")
                }
            }
        }*/
    }
}


extension View {
    func myViewModifier() -> some View {
        modifier(MyViewModifer)
        
    }
}
