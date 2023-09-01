import SwiftUI
import MapKit

let defaultLocation = CLLocationCoordinate2D(latitude: 45.4642700, longitude: 9.1895100)

struct MapView: UIViewRepresentable {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Location.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Location.timestamp, ascending: true)]) var locations: FetchedResults<Location>
    @FetchRequest(entity: DangerousLocation.entity(), sortDescriptors: []) var dangerousLocations: FetchedResults<DangerousLocation>
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        let regionParameters = centerRegion(locations: locations)
        let region = MKCoordinateRegion(center: regionParameters.0, span: regionParameters.1)
        mapView.setRegion(region, animated: false)
        
        let coordinates = locations.map { location in
            CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
        
        let coordinates2 = [
            defaultLocation,
            CLLocationCoordinate2D(latitude: 45.44587, longitude: 9.213108),
            CLLocationCoordinate2D(latitude: 45.448494, longitude: 9.209380),
            CLLocationCoordinate2D(latitude: 45.454847, longitude: 9.219996),
            CLLocationCoordinate2D(latitude: 45.476471, longitude: 9.231198)
        ]
        
        mapView.addOverlay(MKPolyline(coordinates: coordinates2, count: coordinates2.count), level: .aboveLabels)
    
        
        for dangerousLocation in dangerousLocations {
            var locations : [Location] = [];
            if(dangerousLocation.locations != nil) {
                locations = dangerousLocation.locations!.allObjects as! [Location]
            }
            let coordinates = locations.map { location in
                CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            }
            
                
            let coordinates2 = [
                defaultLocation,
                CLLocationCoordinate2D(latitude: 45.44587, longitude: 9.213108),
                CLLocationCoordinate2D(latitude: 45.476471, longitude: 9.231198)
            ]
            
            mapView.addOverlay(MKPolyline(coordinates: coordinates2, count: coordinates2.count), level: .aboveLabels)
            
            // TODO add additional information to the annotation (duration, direction)
            let middleIndex : Int = Int(locations.count / 2)
            let medianLocation = locations[middleIndex]
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: medianLocation.latitude, longitude: medianLocation.longitude)
            mapView.addAnnotation(annotation)
                                                    
        }
        return mapView
    }
    
    func createPolyLine(locations : [Location]) -> MKPolyline {
        let coordinates = locations.map { location in
            CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude);
        }
        return MKPolyline(coordinates: coordinates, count: coordinates.count)
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
            return (defaultLocation, MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        }
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Update the view if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

struct FinalMapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapView
    
    init(_ parent: MapView) {
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
      if let routePolyline = overlay as? MKPolyline {
        let renderer = MKPolylineRenderer(polyline: routePolyline)
        renderer.strokeColor = UIColor.systemBlue
        renderer.lineWidth = 5
        return renderer
      }
      return MKOverlayRenderer()
    }
}

