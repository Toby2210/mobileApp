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
    @State private var conformPassword: String = ""
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
                SecureField("Conform password", text: $conformPassword)
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
            
            
            HStack{
                Button(action: {
                    isRegisterMode.toggle()
                    
                }) {
                    if isRegisterMode {
                        Text("Back to login").foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    } else {
                        Text("Register").foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding()
                Button(action: {
                    if isRegisterMode {
                        register(email: email, password: password, conformPassword: conformPassword){
                            result in
                                                switch result {
                                                case .success(let user):
                                                    print("註冊成功，用戶ID：\(user.uid)")
                                                    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                                                        if let error = error {
                                                            self.error = error.localizedDescription
                                                        } else {
                                                            DispatchQueue.main.async {
                                                                            self.isLoggedIn = true // 登入成功後設置為true
                                                                        }
                                                            
                                                        }
                                                    }

                                                case .failure(let error):
                                                    print("註冊失敗，錯誤：\(error.localizedDescription)")
                                                    self.error = "\(error.localizedDescription)"
                                                }
                            
                            
                            
                        }
                        
                        
                        
                    }
                        else {
                        login()
                    }
                }) {
                    if isRegisterMode {
                        Text("Register")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }else {
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
    func register(email: String, password: String, conformPassword: String, completion: @escaping (Result<User, Error>) -> Void) {
        if password != conformPassword {
            error = "Password and conforming password is not the same"
        }else {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    completion(.failure(error))
                } else if let user = authResult?.user {
                    completion(.success(user))
                }
            }
        }
    }
    
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.error = error.localizedDescription
            } else {
                DispatchQueue.main.async {
                                self.isLoggedIn = true // 登入成功後設置為true
                            }
                
            }
        }
    }
}

