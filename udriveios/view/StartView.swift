import SwiftUI

/* View that requests the location authorization to the user (if not already granted) */
struct StartView: View {
    @State private var showStopAlert = false;
    @State var startDrive : Bool = false;
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var locationManager : LocationManager = LocationManager.getInstance();
    
    var body: some View {
        NavigationStack {
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
                        if (locationManager.status == .notDetermined) {
                            locationManager.requestLocationAuthorization()
                            // awaits for the user to respond to the localization request
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: startDrivingIfAuthorized)
                        } else {
                            startDrivingIfAuthorized()
                        }
                    })
                    .padding([.top], 50)
                    .buttonStyle(CustomButtonStyle())
                    .font(.largeTitle)
                }
                Spacer()
                
                .navigationBarTitle("uDrive")
                .navigationBarBackButtonHidden(true)
                .navigationDestination(isPresented: $startDrive) {
                    HomeView()
                }
            }
            .alert(isPresented: $showStopAlert) {
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
    
    
    func startDrivingIfAuthorized() {
        if (locationManager.authorized) {
            CoreDataManager.getInstance().context = viewContext
            locationManager.startRecordingLocations()
            startDrive = true;
        } else {
            showStopAlert = true
            startDrive = false;
        }
    }
    
    
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
