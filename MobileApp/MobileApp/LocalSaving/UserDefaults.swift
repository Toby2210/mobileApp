//
//  UserDefaults.swift
//  MobileApp
//
//  Created by Toby Pang on 15/1/2024.
//

import Foundation

extension UserDefaults {
    private static let appDataKey = "com.yourapp.appData"
    
    static func saveAppData(_ appData: AppData) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(appData) {
            standard.set(encodedData, forKey: appDataKey)
        }
    }
    
    static func loadAppData() -> AppData? {
        if let savedData = standard.data(forKey: appDataKey) {
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode(AppData.self, from: savedData) {
                return decodedData
            }
        }
        return nil
    }
}
