import SwiftUI
import MapKit

let defaultLocation = CLLocationCoordinate2D(latitude: 45.4642700, longitude: 9.1895100)

/* View showing the user path recorded during the run, highlighting the zones where
   dangerous behaviour was detected   */
struct MapView: UIViewRepresentable {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Location.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Location.timestamp, ascending: true)]) var locations: FetchedResults<Location>
    @FetchRequest(entity: DangerousLocation.entity(), sortDescriptors: []) var dangerousLocations: FetchedResults<DangerousLocation>
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        //The map region is created based on the location recorded
        let regionParameters = centerRegion(locations: locations)
        let region = MKCoordinateRegion(center: regionParameters.0, span: regionParameters.1)
        mapView.setRegion(region, animated: false)
        
        let coordinates = locations.map { location in
            CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
                
        mapView.addOverlay(MKPolyline(coordinates: coordinates, count: coordinates.count), level: .aboveLabels)
        
        context.coordinator.isDangerous = false
        if (coordinates.first != nil && coordinates.last != nil) {
            print("first and last coordinates: \(coordinates.first)\(coordinates.last)")
            let start = MKPointAnnotation()
            start.coordinate = CLLocationCoordinate2D(latitude: coordinates.first!.latitude, longitude: coordinates.first!.longitude)
            mapView.addAnnotation(start)
            
            let end = MKPointAnnotation()
            end.coordinate = CLLocationCoordinate2D(latitude: coordinates.last!.latitude, longitude: coordinates.last!.longitude)
            mapView.addAnnotation(end)
        }
        
        /*For each dangerous location object, another path is created using the locations in it to highlight the dangerous behaviour detected.*/
        for dangerousLocation in dangerousLocations {
            var locations : [Location] = [];
            if(dangerousLocation.locations != nil) {
                locations = dangerousLocation.locations!.allObjects as! [Location]
            }
            let coordinates = locations.map { location in
                CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            }
            context.coordinator.isDangerous = true
            mapView.addOverlay(MKPolyline(coordinates: coordinates, count: coordinates.count), level: .aboveLabels)
            
            let middleIndex : Int = Int(locations.count / 2)
            let medianLocation = locations[middleIndex]
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: medianLocation.latitude, longitude: medianLocation.longitude)
            annotation.title = Direction.getName(direction: dangerousLocation.direction)
            annotation.subtitle = Utils.getFormattedTime(duration: dangerousLocation.duration)
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
    
    /* The region is centered based on the minimum and maximum latitude and longitude detected in the locations recorded. */
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
    var isDangerous : Bool = false
    
    init(_ parent: MapView) {
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
      if let routePolyline = overlay as? MKPolyline {
        let renderer = MKPolylineRenderer(polyline: routePolyline)
          renderer.strokeColor = isDangerous ? UIColor.systemRed : UIColor.systemBlue
        renderer.lineWidth = 5
        return renderer
      }
      return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("Dangerous: \(isDangerous)\n annotation: \(annotation)")

        if !(annotation is MKPointAnnotation) {
            return nil
        }
        if (self.isDangerous == false) {
            let annotationIdentifier = "annotationIdentifier"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
                
            if annotationView == nil {
               annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
                annotationView!.canShowCallout = true
            } else {
                annotationView!.annotation = annotation
            }
            annotationView!.image = UIImage(systemName: "flag.checkered")
            return annotationView
        }
        return nil
    }
}

