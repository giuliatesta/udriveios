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
    @StateObject private var coreDataManager = CoreDataManager.getInstance()
        
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environment(\.managedObjectContext, coreDataManager.persistentContainer.viewContext)  // persistent stack
                
                if launchScreenState.state != .finished {
                    LoadingView()
                }
            }.environmentObject(launchScreenState)
        }
    }
}
