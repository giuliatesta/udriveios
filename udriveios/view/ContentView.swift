import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var launchScreenState: LaunchScreenStateManager
    
    var body: some View {
        StartView()
        .task {
            try? await getDataFromApi()
            try? await Task.sleep(for: Duration.seconds(1))
            self.launchScreenState.dismiss()
            // Stops the IOS screen sleeping
            UIApplication.shared.isIdleTimerDisabled = true
            let coreDataManager = CoreDataManager.getInstance();
            coreDataManager.initManager()       // initialises the database
            coreDataManager.resetData()
        }
    }
    
    fileprivate func getDataFromApi() async throws {
        let googleURL = URL(string: "https://www.google.com")!
        let (_,_) = try await URLSession.shared.data(from: googleURL)
    }
}
/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    
        ContentView()
            .preferredColorScheme(.light)
        
        
    }
}*/
