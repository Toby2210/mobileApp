//
//  List.swift
//  MobileApp
//
//  Created by Toby Pang on 15/1/2024.
//

import SwiftUI

struct Medication: Identifiable, Codable {
    var id = UUID()
    var name: String    //Drug name
    var takingTime: String  //When to take the drug
    var isTaken: Bool   //Is the drug taken?
    var lastModifiedTime: Date
}

// percentage of each day about taking drug
struct MedicationRecord : Identifiable, Codable {
    var id = UUID()
    let percentage: Int
    let recordDate: Date
}

class ListManager: ObservableObject {
    @Published var medications: [Medication] = []   //List of drugs
    @Published var medicationRecords: [MedicationRecord] = []
    @Published var isEditing = false
    @Published var isAdding = false
    @Published var newMedicationName = ""
    @Published var newMedicationTakingTime = "00:00"
    
    // creat "00:00" until "23:30" option
    let timeIntervals = stride(from: 0, to: 24 * 60, by: 30).map { minutes -> String in
        let hour = minutes / 60
        let minute = minutes % 60
        return String(format: "%02d:%02d", hour, minute)
    }
    
    // adding new drug to drugs list
    func addNewMedication() {
        medications.append(Medication(name: newMedicationName, takingTime: newMedicationTakingTime, isTaken: false, lastModifiedTime: Date()))
        FirebaseManager.shared.saveMedications(medications)
        calculateMedicationPercentage()
        isAdding = false
        newMedicationName = ""
        newMedicationTakingTime = "00:00"
        saveData()
        print("Data is added")
    }
    
    func addFromAI(newName: String) {
        medications.append(Medication(name: newName, takingTime: newMedicationTakingTime, isTaken: false, lastModifiedTime: Date()))
        FirebaseManager.shared.saveMedications(medications)
        calculateMedicationPercentage()
        isAdding = false
        newMedicationName = ""
        newMedicationTakingTime = "00:00"
        saveData()
        print("Data is added using addFromAI")
    }
    
    // delete a record from the list
    func delete(at offsets: IndexSet) {
        medications.remove(atOffsets: offsets)
        FirebaseManager.shared.saveMedications(medications)
        calculateMedicationPercentage()
        saveData()
        print("Data is deleted")
    }
    
    // toggle the status of the drug
    func toggleIsTaken(for medication: Medication) {
        if let index = medications.firstIndex(where: { $0.id == medication.id }) {
            medications[index].isTaken.toggle()
            medications[index].lastModifiedTime = Date()
            FirebaseManager.shared.saveMedications(medications)
        }
        calculateMedicationPercentage()
        saveData()
        print("Data is toggled")
    }
    
    // move the position of the drug from the list
    func move(from source: IndexSet, to destination: Int) {
        medications.move(fromOffsets: source, toOffset: destination)
        FirebaseManager.shared.saveMedications(medications)
        saveData()
        print("Data is moved")
    }
    
    // calculate the percentage of today and send it back to the firebase database
    func calculateMedicationPercentage() {
        let currentDate = Date()
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: currentDate)
        
        let takenCount = medications.filter { $0.isTaken }.count
        if medications.count != 0 {
            let percentage = Int((Double(takenCount) / Double(medications.count)) * 100)
            
            // Create new MedicationRecord locally for today
            let medicationRecord = MedicationRecord(percentage: percentage, recordDate: today)
            
            // Update medicationRecords locally for today
            if let todayRecordIndex = medicationRecords.firstIndex(where: { calendar.isDate($0.recordDate, inSameDayAs: today) }) {
                medicationRecords[todayRecordIndex] = medicationRecord
            } else {
                medicationRecords.append(medicationRecord)
            }
            
            saveData()
            print("Percentage is calculated and medicationRecords is updated locally")
            
            // Send today's record to Firebase
            FirebaseManager.shared.saveMedicationPercentage([medicationRecord])
        }
    }
//    func calculateMedicationPercentage() {
//        // Calculate
//        let takenCount = medications.filter { $0.isTaken }.count
//        if medications.count != 0 {
//            let percentage = Int((Double(takenCount) / Double(medications.count)) * 100)
//            
//            let currentDate = Date()
//            let medicationRecord = MedicationRecord(percentage: percentage, recordDate: currentDate)
//            var data = [MedicationRecord]()
//            data.append(medicationRecord)
//            // Send to firebase
//            FirebaseManager.shared.saveMedicationPercentage(data)
//            loadMedicationRecords()
//            print("Percentage is calculated")
//        }
//    }
    // get the data from firebase
    func loadUserMedications() {
        FirebaseManager.shared.loadUserMedications { medications in
            DispatchQueue.main.async {
                let calendar = Calendar.current
                let today = calendar.startOfDay(for: Date())
                
                var updatedMedications = medications
                // check if the data has already passed a day or not
                // if the last modified time is before today, the isTaken will be changed to false
                for index in 0..<updatedMedications.count {
                    let medication = updatedMedications[index]
                    let medicationDate = calendar.startOfDay(for: medication.lastModifiedTime)
                    
                    if !calendar.isDate(medicationDate, inSameDayAs: today) {
                        updatedMedications[index].isTaken = false
                        updatedMedications[index].lastModifiedTime = today
                    }
                }
                // update the list of the app
                self.medications = updatedMedications
                // update the list and send back to firebase
                FirebaseManager.shared.saveMedications(self.medications)
                self.calculateMedicationPercentage()
                self.saveData()
                print("Data is loaded from Firebase")
            }
        }
    }
    
    func sort() {
        withAnimation {
            medications.sort { (medication1, medication2) -> Bool in
                if medication1.takingTime != medication2.takingTime {
                    return medication1.takingTime < medication2.takingTime
                } else {
                    return medication1.name < medication2.name
                }
            }
            FirebaseManager.shared.saveMedications(self.medications)
            saveData()
            print("Reminder list is sorted")
        }
    }
    // save to local
    func saveData() {
        let appData = AppData(medications: self.medications, medicationRecords: self.medicationRecords)
        UserDefaults.saveAppData(appData)
        print("Data is saved to local")
    }
    // load from local
    func loadData() {
        if let appData = UserDefaults.loadAppData() {
            self.medications = appData.medications
            self.medicationRecords = appData.medicationRecords
        }
        print("Data is loaded from local")
        FirebaseManager.shared.saveMedications(medications)
        calculateMedicationPercentage()
    }
    func loadMedicationRecords() {
        // get the record date from firebase
        FirebaseManager.shared.loadUserMedicationRecords { records in
            DispatchQueue.main.async {
                self.medicationRecords = records
                self.saveData()
            }
        }
    }
    
}
