//
//  udriveiosApp.swift
//  udriveios
//
//  Created by Giulia Testa on 26/04/23.
//

import SwiftUI

@main
struct udriveiosApp: App {
    @StateObject var launchScreenState = LaunchScreenStateManager()
        
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                
                if launchScreenState.state != .finished {
                    LoadingView()
                }
            }.environmentObject(launchScreenState)
        }
    }
}
