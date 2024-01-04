//
//  ListView.swift
//  MobileApp
//
//  Created by Toby Pang on 30/12/2023.
//

import SwiftUI


struct Medication: Identifiable {
    let id = UUID()
    var name: String    //Drug name
    var takingTime: String  //When to take the drug
    var isTaken: Bool   //Is the drug is taken?
    var lastModifiedTime: Date
}

struct ListView: View {
    @State private var medications: [Medication] = []   //List of the drugs
        @State private var isEditing = false
        @State private var isAdding = false
        @State private var newMedicationName = ""
    @State private var newMedicationTakingTime = "00:00"
    @State private var newLastModifiedTime = "00:00"
    
    let timeIntervals = stride(from: 0, to: 24 * 60, by: 30).map { minutes -> String in
        let hour = minutes / 60
        let minute = minutes % 60
        return String(format: "%02d:%02d", hour, minute)
    }
        var body: some View {
            NavigationView {
                VStack {
                    List {
                        ForEach(medications) { medication in
                            HStack {
                                Text(medication.name)
                                Spacer()
                                Text(medication.takingTime)
                                if !isEditing {
                                    Button(action: {
                                        toggleIsTaken(for: medication)
                                    }) {
                                        Image(systemName: medication.isTaken ? "checkmark.square" : "square")
                                    }
                                }
                            }
                        }
                        .onDelete(perform: delete)
                        .onMove(perform: move)
                        
                        if isEditing {
                            EditButton()
                                .padding()
                                .onTapGesture {
                                    withAnimation {
                                        isAdding = true
                                    }
                                }
                        }
                    }
                    HStack {
                        TextField("Name", text: $newMedicationName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        Picker("Taking time", selection: $newMedicationTakingTime) {
                            ForEach(timeIntervals, id: \.self) { time in
                                Text(time).tag(time)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        
                        Button(action: {
                            if !newMedicationName.isEmpty {
                                addNewMedication()
                            }
                        }) {
                            Text("Add")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                    .navigationTitle("Medication List")
                    .navigationBarItems(trailing: EditButton())
                    .sheet(isPresented: $isAdding) {
                        addMedicationSheet
                    }
                    .onAppear {
                                loadUserMedications()
                            }
                    
                }
            }
        }
        var addMedicationSheet: some View {
            VStack {
                Form {
                    TextField("Medication Name", text: $newMedicationName)
                    TextField("Taking Time", text: $newMedicationTakingTime)
                }
                Button(action: {
                    addNewMedication()
                }) {
                    Text("Add")
                }
            }
            .navigationTitle("Add Medication")
        }
        
    func addNewMedication() {
        medications.append(Medication(name: newMedicationName, takingTime: newMedicationTakingTime, isTaken: false, lastModifiedTime: Date()))
        FirebaseManager.shared.saveMedications(medications)
        isAdding = false
        newMedicationName = ""
        newMedicationTakingTime = ""
        newLastModifiedTime = ""
    }

    func delete(at offsets: IndexSet) {
        medications.remove(atOffsets: offsets)
        FirebaseManager.shared.saveMedications(medications)
    }

    func toggleIsTaken(for medication: Medication) {
        if let index = medications.firstIndex(where: { $0.id == medication.id }) {
            medications[index].isTaken.toggle()
            medications[index].lastModifiedTime = Date()
            FirebaseManager.shared.saveMedications(medications)
        }
    }

    func move(from source: IndexSet, to destination: Int) {
        medications.move(fromOffsets: source, toOffset: destination)
        FirebaseManager.shared.saveMedications(medications)
    }
    
    func loadUserMedications() {
        FirebaseManager.shared.loadUserMedications { medications in
            DispatchQueue.main.async {
                let calendar = Calendar.current
                let today = calendar.startOfDay(for: Date())
                
                var updatedMedications = medications
                
                for index in 0..<updatedMedications.count {
                    let medication = updatedMedications[index]
                    let medicationDate = calendar.startOfDay(for: medication.lastModifiedTime) // 获取medication的凌晨时间
                    
                    if calendar.isDate(medicationDate, inSameDayAs: today) == false {
                        updatedMedications[index].isTaken = false
                    }
                }
                
                self.medications = updatedMedications
                FirebaseManager.shared.saveMedications(self.medications)
            }
        }
    }
    
    
}
