//
//  SettingView.swift
//  MobileApp
//
//  Created by Toby Pang on 30/12/2023.
//

import SwiftUI
import FirebaseAuth
struct SettingView: View {
    @Binding var isLoggedIn: Bool // 登出狀態的綁定屬性
    let yourEmail = Auth.auth().currentUser?.email ?? ""
        var body: some View {
            VStack {
                Text("Your Email is: \(yourEmail)")
                Button(action: {
                                // 執行登出操作
                                do {
                                    try Auth.auth().signOut()
                                    isLoggedIn = false // 更新登出狀態
                                } catch {
                                    print("登出時發生錯誤：\(error.localizedDescription)")
                                }
                            }) {
                    Text("Logout")
                        .foregroundColor(.red)
                }
            }
        }
}


