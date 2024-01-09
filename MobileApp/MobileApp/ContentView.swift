//
//  ContentView.swift
//  MobileApp
//
//  Created by Toby Pang on 19/12/2023.
//

import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseAuth
import MapKit
import CoreLocation
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
    
}
struct Hospital {
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct ContentView: View {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var isLoggedIn = false
    @StateObject var locationModel = LocationModel()
    @StateObject private var locationManager = LocationModel()
    let hospitals = [
        Hospital(name: "Tuen Mun Hospital", coordinate: CLLocationCoordinate2D(latitude: 22.40768, longitude: 113.97600)),
        Hospital(name: "Queen Elizabeth Hospital", coordinate: CLLocationCoordinate2D(latitude: 22.30944, longitude: 114.17556))
    ]
    
    var body: some View {
        if isLoggedIn {
            TabView {
                ListView()
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("List")
                    }
                
                RecordView()
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Record")
                    }
                
                MapView(hospitals: hospitals)
                    .tabItem {
                        Image(systemName: "map")
                        Text("Map")
                    }
                AIView()
                    .tabItem {
                        Image(systemName: "eye")
                        Text("AI")
                    }
                
                SettingView(isLoggedIn: $isLoggedIn)
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Setting")
                    }
            }
        } else {
            LoginView(isLoggedIn: $isLoggedIn).onAppear {
                checkLoginStatus()
            }
        }
    }
    
    func checkLoginStatus() {
        if Auth.auth().currentUser != nil {
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
    }
}



#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
