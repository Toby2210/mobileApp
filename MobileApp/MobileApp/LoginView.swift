//
//  LoginView.swift
//  MobileApp
//
//  Created by Toby Pang on 30/12/2023.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var error: String = ""
    @Binding var isLoggedIn: Bool
    @State private var isRegisterMode = false
    
    var body: some View {
        VStack {
            if isRegisterMode {
                Text("Register")
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Confirm password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            } else {
                Text("Login")
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            
            HStack {
                Button(action: {
                    isRegisterMode.toggle()
                }) {
                    if isRegisterMode {
                        Text("Back to login")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    } else {
                        Text("Register")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding()
                
                Button(action: {
                    if isRegisterMode {
                        register()
                    } else {
                        login()
                    }
                }) {
                    if isRegisterMode {
                        Text("Register")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    } else {
                        Text("Login")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            
            Text(error)
                .foregroundColor(.red)
                .padding()
        }
        .padding()
    }
    
    private func register() {
        FirebaseManager.shared.register(email: email, password: password, confirmPassword: confirmPassword) { result in
            switch result {
            case .success(let user):
                print("Registration success, user id: \(user.uid)")
                login()
            case .failure(let error):
                print("Registration failed, error: \(error.localizedDescription)")
                self.error = error.localizedDescription
            }
        }
    }
    
    private func login() {
        FirebaseManager.shared.login(email: email, password: password) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.isLoggedIn = true
                }
            case .failure(let error):
                self.error = error.localizedDescription
            }
        }
    }
}






