//
//  FirebaseManager.swift
//  MobileApp
//
//  Created by Toby Pang on 3/1/2024.
//

import Foundation
import FirebaseAuth //For login system
import FirebaseDatabase //For data saving

class FirebaseManager {
    static let shared = FirebaseManager()
    
    private let databaseRef = Database.database().reference()
    
    private init() {}
    
    // Register
    func register(email: String, password: String, confirmPassword: String, completion: @escaping (Result<User, Error>) -> Void) {
        if password != confirmPassword {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Password and confirm password are not same"])))
        } else {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    completion(.failure(error))
                } else if let user = authResult?.user {
                    completion(.success(user))
                }
            }
        }
    }
    
    // Login
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                completion(.success(user))
            }
        }
    }
    
    // Loading list
    func loadUserMedications(completion: @escaping ([Medication]) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }
        // get data from firebase
        databaseRef.child("medications").child(currentUserID).observeSingleEvent(of: .value, with: { snapshot in
            guard let medicationsData = snapshot.value as? [[String: Any]] else {
                completion([])
                return
            }
            // save the date to teh medicationsData forment
            let medications = medicationsData.compactMap { data -> Medication? in
                guard let name = data["name"] as? String,
                      let takingTime = data["takingTime"] as? String,
                      let isTaken = data["isTaken"] as? Bool,
                      let lastModifiedTime = data["lastModifiedTime"] as? TimeInterval else {
                    return nil
                }
                
                return Medication(name: name, takingTime: takingTime, isTaken: isTaken, lastModifiedTime: Date(timeIntervalSince1970: lastModifiedTime))
            }
            
            completion(medications)
        })
    }
    
    // Loading medication records
    func loadUserMedicationRecords(completion: @escaping ([MedicationRecord]) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // get data from firebase
        databaseRef.child("medicationPercentage").child(currentUserID).observeSingleEvent(of: .value) { snapshot in
            var medicationRecords: [MedicationRecord] = []
            
            guard let dateSnapshots = snapshot.value as? [String: Any] else {
                completion([])
                return
            }
            // save the date to teh MedicationRecord forment
            for (_, recordData) in dateSnapshots {
                guard let recordData = recordData as? [String: Any],
                    let percentage = recordData["percentage"] as? Int,
                    let recordDateTimestamp = recordData["recordDate"] as? TimeInterval else {
                        continue
                }
                
                let recordDate = Date(timeIntervalSince1970: recordDateTimestamp)
                let medicationRecord = MedicationRecord(percentage: percentage, recordDate: recordDate)
                medicationRecords.append(medicationRecord)
            }
            
            completion(medicationRecords)
        }
    }
    
    
    
    
    // send the list data to firebase
    func saveMedications(_ medications: [Medication]) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let medicationsData = medications.map { medication -> [String: Any] in
            return [
                "name": medication.name,
                "takingTime": medication.takingTime,
                "isTaken": medication.isTaken,
                "lastModifiedTime": medication.lastModifiedTime.timeIntervalSince1970
            ]
        }
        
        databaseRef.child("medications").child(currentUserID).setValue(medicationsData)
    }
    
    
    
    // send the record data to firebase
    func saveMedicationPercentage(_ records: [MedicationRecord]) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for record in records {
            let dateString = dateFormatter.string(from: record.recordDate)
            
            let percentageData: [String: Any] = [
                "percentage": record.percentage,
                "recordDate": record.recordDate.timeIntervalSince1970
            ]
            
            let userRef = databaseRef.child("medicationPercentage").child(currentUserID).child(dateString)
            userRef.setValue(percentageData) { error, _ in
                if let error = error {
                    print("Error saving medication percentage to Firebase: \(error.localizedDescription)")
                } else {
                    print("Medication percentage saved successfully.")
                }
            }
        }
    }
    
    
}
