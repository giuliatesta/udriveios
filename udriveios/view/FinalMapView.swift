import SwiftUI
import MapKit

struct FinalMapView: UIViewRepresentable {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Location.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Location.timestamp, ascending: true)]) var locations: FetchedResults<Location>
    
    func makeUIView(context: Context) -> MKMapView {
        let initialPosition = CLLocationCoordinate2D(latitude: 45.4642700, longitude: 9.1895100)
        
        if let firstLocation = locations.first {
            var minLat = firstLocation.latitude
            var maxLat = firstLocation.latitude
            var minLong = firstLocation.longitude
            var maxLong = firstLocation.longitude
            for location in locations {
                minLat = min(minLat, location.latitude)
                maxLat = max(maxLat, location.latitude)
                minLong = min(minLong, location.longitude)
                maxLong = max(maxLong, location.longitude)
            }
        }
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: initialPosition.latitude, longitude: initialPosition.longitude), span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
    

        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        mapView.setRegion(region, animated: false)
        
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            mapView.addAnnotation(annotation)
        }
        
        // Create an MKPolyline with the coordinates
        // TODO check user's path
        let polyline = MKPolyline(coordinates: locations.map(
            (location) -> CLLocationCoordinate2D(
                latitude: location.latitude,
                longitude: location.longitude)),
            count: locations.count)
        mapView.addOverlay(polyline)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Update the view if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: FinalMapView
        
        init(_ parent: FinalMapView) {
            self.parent = parent
        }
    }
}

struct FinalMapView_Previews: PreviewProvider {
    static var previews: some View {
        FinalMapView()
    }
}

