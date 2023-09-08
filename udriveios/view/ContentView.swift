import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var launchScreenState: LaunchScreenStateManager
    
    var body: some View {
        StartView()
        .task {
            try? await getDataFromApi()
            try? await Task.sleep(for: Duration.seconds(1))
            self.launchScreenState.dismiss()
            let coreDataManager = CoreDataManager.getInstance();
            coreDataManager.initManager()                                   // initialises the database
            coreDataManager.deleteEntity(entityName: "Location")            // empties the locations table -> only the current session is saved
            coreDataManager.deleteEntity(entityName: "DangerousLocation")   // empties the DangerousLocation table
            coreDataManager.deleteEntity(entityName: "ElapsedTime")   // empties the ElapsedTime table
        }
    }
    
    fileprivate func getDataFromApi() async throws {
        let googleURL = URL(string: "https://www.google.com")!
        let (_,_) = try await URLSession.shared.data(from: googleURL)
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
