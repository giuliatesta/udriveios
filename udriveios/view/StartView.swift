import SwiftUI

/* View that requests the location authorization to the user (if not already granted) */
struct StartView: View {
    @State private var showStopAlert = false;
    @State var authorizationDenied : Bool = false;
    @State var canProceed : Bool = false;
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationView {
            VStack (alignment: .center) {
                GifImage("rotate_phone").frame(width: 150, height: 150, alignment: .center)
                // TODO centrare la scritta
                Text("Metti il tuo telefono in verticale")
                    .font(fontSystem)
                Button(action: {
                    let locationManager = LocationManager.getInstance()
                    locationManager.requestLocationAuthorization()
                    if(locationManager.isAuthorizationGranted()) {
                           CoreDataManager.getInstance().context = viewContext
                           locationManager.startRecordingLocations()
                           canProceed = true;
                       } else {
                           authorizationDenied = true
                           canProceed = false;
                       }
                       print("canProceed action: \(canProceed)")
                    })
                    {
                        Text("Inizia la guida").font(.title)
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                NavigationLink(destination: HomeView(), isActive: $canProceed) {
                    EmptyView()
                }
            }
            .alert(isPresented: $authorizationDenied) {
                Alert(
                    title: Text("Accesso alla posizione negato"),
                    message: Text("Per utilizzare la applicazione, è necessario dare l'accesso alla propria posizione. Vai nelle impostazioni per modificare."),
                    primaryButton: .default(Text("Esci"), action: {
                        exit(0) // This will forcefully exit the app
                    }),
                    secondaryButton: .cancel()
                )
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
