//
//  MedicationNotificationManager.swift
//  MobileApp
//
//  Created by Toby Pang on 16/1/2024.
//

import SwiftUI
import UserNotifications

class MedicationNotificationManager{
    static let shared = MedicationNotificationManager()
    
    private init() {}
    
    func notificationRequest() {
        let center = UNUserNotificationCenter.current()
        
        // check the request status
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                print("Notification Permission Already Set!")
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("Notification Permission Set!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func setNotification(medications: [Medication]) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        if medications.count != 0 {

            
            var medicationCountsByTime: [String: Int] = [:]
            
            // only count isTaken = false
            let pendingMedications = medications.filter { !$0.isTaken }
            
            for medication in pendingMedications {
                let takingTime = medication.takingTime
                
                if let count = medicationCountsByTime[takingTime] {
                    medicationCountsByTime[takingTime] = count + 1
                } else {
                    medicationCountsByTime[takingTime] = 1
                }
            }
            
            for (takingTime, count) in medicationCountsByTime {
                let content = UNMutableNotificationContent()
                content.title = "Medication Notification"
                content.subtitle = "You have \(count) medication(s) to take at \(takingTime)"
                print(content.subtitle)
                
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm"
                guard let date = timeFormatter.date(from: takingTime) else {
                    print("Invalid time format: \(takingTime)")
                    continue
                }
                
                let calendar = Calendar.current
                let timeComponents = calendar.dateComponents([.hour, .minute], from: date)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: timeComponents, repeats: true)
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                center.add(request) { error in
                    if let error = error {
                        print("Failed to schedule notification: \(error)")
                    }
                }
            }
        }
    }
    
    
    
}
