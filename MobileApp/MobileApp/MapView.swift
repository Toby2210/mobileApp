//
//  MapView.swift
//  MobileApp
//
//  Created by Toby Pang on 30/12/2023.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @StateObject private var locationManager = LocationModel()
    let mapView = MKMapView()
    let hospitals: [Hospital]
    @State var coordinateRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                                                                          span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        
        for hospital in hospitals {
            let annotation = MKPointAnnotation()
            annotation.coordinate = hospital.coordinate
            annotation.title = hospital.name
            mapView.addAnnotation(annotation)
        }
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeAnnotations(mapView.annotations)
        for hospital in hospitals {
            let annotation = MKPointAnnotation()
            annotation.coordinate = hospital.coordinate
            annotation.title = hospital.name
            mapView.addAnnotation(annotation)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView.canShowCallout = true
            let infoButton = UIButton(type: .infoLight)
            annotationView.rightCalloutAccessoryView = infoButton
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if let coordinate = view.annotation?.coordinate {
                let placemark = MKPlacemark(coordinate: coordinate)
                let mapItem = MKMapItem(placemark: placemark)
                mapItem.name = view.annotation?.title ?? ""
                mapItem.openInMaps(launchOptions: nil)
            }
        }
    }
}
