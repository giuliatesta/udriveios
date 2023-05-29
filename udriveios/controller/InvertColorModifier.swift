//
//  myViewModifier.swift
//  udriveios
//
//  Created by Giulia Testa on 26/04/23.
//

import Foundation
import SwiftUI



struct InvertColorModifier : ViewModifier{
    @Environment (\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        if(colorScheme == .dark){
            content.colorInvert()
        } else {
            content
        }
    }
    
}

extension Image {

    func fillImageModifier() -> some View {
        self.resizable()
            .aspectRatio(contentMode: .fill)
    }
    
    func fitImageModifier() -> some View {
        self.resizable()
            .aspectRatio(contentMode: .fit)
    }
}

extension View {
    func invertColorModifier() -> some View {
        modifier(InvertColorModifier())
        
    }
}

