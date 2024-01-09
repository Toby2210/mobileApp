//
//  LocationManager.swift
//  MobileApp
//
//  Created by Toby Pang on 9/1/2024.
//

import SwiftUI
import Foundation
import CoreLocation
import MapKit
class LocationModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus
    
    @Published var lastLocation: CLLocation?
    
    @Published var coordinateRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0,
                                                                                                             longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
    
    private let locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            self.lastLocation = locations.last

            if let lastLocation = self.lastLocation {
                self.coordinateRegion = MKCoordinateRegion(center: lastLocation.coordinate,
                                                           span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            }
        }
    }
}
