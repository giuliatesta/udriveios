import SwiftUI

let dropShadow = Color(hex: "aeaec0").opacity(0.4)
let dropLight = Color(hex: "ffffff")

/* View that requests the location authorization to the user (if not already granted) */
struct StartView: View {
    @State private var showStopAlert = false;
    @State var authorizationDenied : Bool = false;
    @State var canProceed : Bool = false;
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationView {
            VStack {
                GifImage("car_animation")
                    .frame(width: 550,
                           height: 300,
                           alignment: .topLeading)
                
                VStack (alignment: .center) {
                   /* Text("Metti il tuo telefono in verticale")
                     .font(fontSystem) */
                    Button("Inizia la guida", action: {
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
                    .buttonStyle(CustomButtonStyle())
                    .font(.largeTitle)
                }
                Spacer()
                NavigationLink(destination: HomeView(), isActive: $canProceed) {
                    EmptyView()
                }
                .navigationBarTitle("uDrive")
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
    }
    
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
