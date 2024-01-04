//
//  MobileAppApp.swift
//  MobileApp
//
//  Created by Toby Pang on 19/12/2023.
//

import SwiftUI
import SwiftData
import Firebase
@main
struct MobileAppApp: App {
    init() {
            FirebaseApp.configure() 
        }
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
            WindowGroup {
                let dateHolder = DateHolder()
                ContentView()
                    .environmentObject(dateHolder)
            }
        }
}
