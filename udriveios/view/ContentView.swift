//
//  ContentView.swift
//  udriveios
//
//  Created by Giulia Testa on 26/04/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var launchScreenState: LaunchScreenStateManager
    
    var body: some View {
        StartView()
        .task {
            try? await getDataFromApi()
            try? await Task.sleep(for: Duration.seconds(1))
            self.launchScreenState.dismiss()
        }
    }
    
    fileprivate func getDataFromApi() async throws {
        let googleURL = URL(string: "https://www.google.com")!
        let (_,response) = try await URLSession.shared.data(from: googleURL)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    
        ContentView()
            .preferredColorScheme(.light)
        
        
    }
}
