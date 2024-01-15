//
//  AppData.swift
//  MobileApp
//
//  Created by Toby Pang on 15/1/2024.
//

import Foundation

struct AppData: Codable {
    var medications: [Medication]
    var medicationRecords: [MedicationRecord]
}
