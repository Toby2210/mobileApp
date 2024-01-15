//
//  ListView.swift
//  MobileApp
//
//  Created by Toby Pang on 30/12/2023.
//

import SwiftUI


struct ListView: View {
    @EnvironmentObject var listManager: ListManager
    var body: some View {
            NavigationView {
                // List of drugs
                VStack {
                    List {
                        ForEach(listManager.medications) { medication in
                            HStack {
                                Text(medication.name)
                                Spacer()
                                Text(medication.takingTime)
                                if !listManager.isEditing {
                                    Button(action: {
                                        listManager.toggleIsTaken(for: medication)
                                    }) {
                                        Image(systemName: medication.isTaken ? "checkmark.square" : "square")
                                    }
                                }
                            }
                        }
                        .onDelete(perform: listManager.delete)
                        .onMove(perform: listManager.move)
                        
                        if listManager.isEditing {
                            EditButton()
                                .padding()
                        }
                    }
                //place for adding new drug to drugs list
                    VStack {
                        Button(action: {listManager.sort()
                        },label: {
                            Text("Sort by taking time")
                        })
                        HStack {
                            TextField("Name", text: $listManager.newMedicationName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                            
                            Picker("Taking time", selection: $listManager.newMedicationTakingTime) {
                                ForEach(listManager.timeIntervals, id: \.self) { time in
                                    Text(time).tag(time)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding()
                            
                            Button(action: {
                                if !listManager.newMedicationName.isEmpty {
                                    listManager.addNewMedication()
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
                    }
                .navigationTitle("Medication List")
                .navigationBarItems(trailing: EditButton())
                .onAppear {
                    listManager.loadUserMedications()
                }
                
            }
        }
    }
    
}
