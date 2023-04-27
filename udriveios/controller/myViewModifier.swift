//
//  myViewModifier.swift
//  udriveios
//
//  Created by Giulia Testa on 26/04/23.
//

import Foundation
import SwiftUI



struct MyViewModifer : ViewModifier{
    func body(content: Content) -> some View {
        content.padding(10)
    }
}


extension View {
    func myViewModifier() -> some View {
        modifier(MyViewModifer())
        
    }
}

