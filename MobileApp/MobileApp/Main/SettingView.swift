//
//  SettingView.swift
//  MobileApp
//
//  Created by Toby Pang on 30/12/2023.
//

import SwiftUI
import FirebaseAuth
struct SettingView: View {
    @Binding var isLoggedIn: Bool
    @State var yourEmail = Auth.auth().currentUser?.email ?? ""
        var body: some View {
            VStack {
                Text("Your Email is: \(yourEmail)")
                Button(action: {
                                do {
                                    try Auth.auth().signOut()
                                    isLoggedIn = false
                                } catch {
                                    print("logout error：\(error.localizedDescription)")
                                }
                            }) {
                    Text("Logout")
                        .foregroundColor(.red)
                }
            }
        }
}


