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

struct Hospital {
    let name: String
    let coordinate: CLLocationCoordinate2D
}

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
        
        if authorizationStatus == .notDetermined {
            DispatchQueue.main.async {
                self.locationManager.requestWhenInUseAuthorization()
            }
        }
        
        locationManager.startUpdatingLocation()
    }
    // hospitals list
    let hospitals = [
        Hospital(name: "Tuen Mun Hospital", coordinate: CLLocationCoordinate2D(latitude: 22.40768, longitude: 113.97600)),
        Hospital(name: "Queen Elizabeth Hospital", coordinate: CLLocationCoordinate2D(latitude: 22.30944, longitude: 114.17556))
    ]
    // print the location data
    func printCurrentLocation() {
        if let location = locationManager.location {
            print("Current Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        } else {
            print("Current Location is not available")
        }
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
