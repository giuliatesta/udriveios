import SwiftUI

/* View that requests the location authorization to the user (if not already granted) */
struct StartView: View {
    @State private var showStopAlert = false;
    @State var authorizationGranted: Bool = false;
    @State var authorizationDenied : Bool = false;
    @State var canProceed : Bool = false;

    @State var locationManager : LocationManager!;
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationView {
            VStack (alignment: .center){
                GifImage("rotate_phone").frame(width: 150, height: 150, alignment: .center)
                // TODO centrare la scritta
                Text("Metti il tuo telefono in verticale")
                    .font(fontSystem)
                   Button(action: {
                       locationManager.requestLocationAuthorization()
                       if(authorizationGranted) {
                           // TODO check assignment
                           CoreDataManager.getInstance().context = viewContext
                           locationManager.startRecordingLocations()
                           canProceed = true;
                       } else {
                           canProceed = false;
                       }
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
        .onAppear() {
            locationManager = LocationManager.getInstance(authorizationDenied: $authorizationDenied, authorizationGranted: $authorizationGranted);
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
