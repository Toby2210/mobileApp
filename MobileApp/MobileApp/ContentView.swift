//
//  ContentView.swift
//  MobileApp
//
//  Created by Toby Pang on 19/12/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
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
            
            MapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
            
            AIView()
                .tabItem {
                    Image(systemName: "eye")
                    Text("AI")
                }
            
            SettingView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Setting")
                }
        }
    }
}



#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
