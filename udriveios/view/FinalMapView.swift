import SwiftUI
import MapKit

let defaultPosition = CLLocationCoordinate2D(latitude: 45.4642700, longitude: 9.1895100)

struct FinalMapView: UIViewRepresentable {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Location.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Location.timestamp, ascending: true)]) var locations: FetchedResults<Location>
    
    func makeUIView(context: Context) -> MKMapView {
        
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        var regionParameters = centerRegion(locations: locations)
        let region = MKCoordinateRegion(center: regionParameters.0, span: regionParameters.1)
        mapView.setRegion(region, animated: false)
        
        // TODO filter the dangerous locations
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            //mapView.addAnnotation(annotation)
        }
        
        let coordinates = locations.map { location in
            CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
    
        // TODO check if it draws the user's path
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = UIColor.black
        renderer.lineWidth = 7
        mapView.addOverlay(renderer.polyline)
        
        //locations.reduce(into: [CLLocationCoordinate2D] ()) {}
        return mapView
    }
    
    func centerRegion(locations: FetchedResults<Location>) -> (CLLocationCoordinate2D, MKCoordinateSpan){
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
            
            let center = CLLocationCoordinate2D(
                latitude: (minLat + maxLat) / 2,
                longitude: (minLong + maxLong) / 2
            )
            
            let span = MKCoordinateSpan(
                latitudeDelta: (maxLat - minLat) * 1.2,
                longitudeDelta: (maxLong - minLong) * 1.2
            )
            return (center, span)
        } else {
            // should never occur...
            return (defaultPosition, MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        }
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

