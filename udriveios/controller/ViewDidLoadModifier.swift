//
//  ViewDidLoadModifier.swift
//  udriveios
//
//  Created by Sara Regali on 15/05/23.
//

import Foundation
import SwiftUI

//View Modifier to detect wether the view was loaded or not

struct ViewDidLoadModifier: ViewModifier {

    @State private var didLoad = false
    private let action: (() -> Void)?

    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content.onAppear {
            if didLoad == false {
                didLoad = true
                action?()
            }
        }
    }

}

extension View {

    func viewDidLoadModifier(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }

}
