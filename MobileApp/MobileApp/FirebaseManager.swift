//
//  FirebaseManager.swift
//  MobileApp
//
//  Created by Toby Pang on 3/1/2024.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class FirebaseManager {
    static let shared = FirebaseManager()
    
    private let databaseRef = Database.database().reference()
    
    private init() {}
    
    // Register
    func register(email: String, password: String, confirmPassword: String, completion: @escaping (Result<User, Error>) -> Void) {
        if password != confirmPassword {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "密碼和確認密碼不匹配"])))
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
        
        databaseRef.child("medications").child(currentUserID).observeSingleEvent(of: .value, with: { snapshot in
            guard let medicationsData = snapshot.value as? [[String: Any]] else {
                completion([])
                return
            }
            
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
    func loadMedicationRecords(completion: @escaping ([MedicationRecord]) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }
        
        databaseRef.child("medicationPercentage").child(currentUserID).observeSingleEvent(of: .value, with:  { snapshot in
            guard let medicationRecordsData = snapshot.value as? [[String: Any]] else {
                completion([])
                return
            }
            
            let medicationRecords = medicationRecordsData.compactMap { data -> MedicationRecord? in
                guard let date = data["date"] as? Date,
                      let percentage = data["percentage"] as? Int else {
                    return nil
                }
                
                return MedicationRecord(date: date, percentage: percentage)
            }
            
            completion(medicationRecords)
        })
    }
    
    
    
    
    
    
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
    
    
    
    
    func saveMedicationPercentage(_ records: [MedicationRecord]) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for record in records {
            let dateString = dateFormatter.string(from: record.date)
            
            let percentageData: [String: Any] = [
                "percentage": record.percentage,
                "recordDate": record.date.timeIntervalSince1970
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
