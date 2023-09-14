import SwiftUI

let dropShadow = Color(hex: "aeaec0").opacity(0.4)
let dropLight = Color(hex: "ffffff")

/* View that requests the location authorization to the user (if not already granted) */
struct StartView: View {
    @State private var showStopAlert = false;
    @State var authorizationGranted: Bool = false;
    @State var authorizationDenied : Bool = false;

    @State var canProceed : Bool = false;
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var locationManager : LocationManager!;
    
    var body: some View {
        NavigationView {
            VStack {
                GifImage("car_animation")
                    .frame(width: 550,
                           height: 300,
                           alignment: .topLeading)
                VStack (alignment: .center) {
                    Text("Metti il telefono in verticale")
                        .multilineTextAlignment(.center)
                     .font(fontSystem)
                     .padding([.top], 20)
                    Button("Inizia la guida", action: {
                        locationManager.requestLocationAuthorization()
                    })
                    .padding([.top], 50)
                    .buttonStyle(CustomButtonStyle())
                    .font(.largeTitle)
                }
                Spacer()
                NavigationLink(destination: HomeView(), isActive: $canProceed) {
                    EmptyView()
                }
                .navigationBarTitle("uDrive")
            }
            .onAppear() {
                locationManager = LocationManager.getInstance(
                    authorizationDenied: $authorizationDenied,
                    authorizationGranted: $authorizationGranted);
            }
            .onChange(of: authorizationGranted, perform: { newValue in
                if(newValue) {
                    CoreDataManager.getInstance().context = viewContext
                    locationManager.startRecordingLocations()
                    canProceed = true;
                } else {
                    canProceed = false;
                }
            })
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
