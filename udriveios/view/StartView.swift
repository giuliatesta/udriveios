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
        NavigationView{
            VStack{
                GifImage("rotate_phone").frame(width: 150, height: 150, alignment: .center)
                Text("Rotate your phone vertically").font(fontSystem)

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
                        Text("Start Driving!").font(.title)
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                NavigationLink(destination: HomeView(), isActive: $canProceed) {
                    EmptyView()
                }
            }
            .alert(isPresented: $authorizationDenied) {
                Alert(
                    title: Text("Location Access Denied"),
                    message: Text("To use this app, we need access to your location."),
                    primaryButton: .default(Text("Exit"), action: {
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
