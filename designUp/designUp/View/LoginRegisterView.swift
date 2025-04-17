//
//  LoginRegisterView.swift
//  designUp
//
//  Created by София Кармаева on 26/3/2025.
//

import SwiftUI

struct LoginRegisterView: View {
    @Binding var isLoggedIn: Bool
    @State private var showingLogin = false
    @State private var showingRegister = false

    var body: some View {
        ZStack {
            Color.darkBlue.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                Text("designUp")
                    .font(.largeTitle)
                    .foregroundStyle(.lightPink)
                
                Spacer()
                
                Button(action: {
                    showingLogin = true
                }) {
                    Text("Вход")
                        .font(.title2)
                        .padding()
                        .background(Color.lightPink)
                        .foregroundColor(Color.darkBlue)
                        .cornerRadius(10)
                }.sheet(isPresented: $showingLogin) {
                    LoginView(isLoggedIn: $isLoggedIn)
                }
                
                Button(action: {
                    showingRegister = true
                }) {
                    Text("Регистрация")
                        .font(.title2)
                        .padding()
                        .background(Color.lightPink)
                        .foregroundColor(Color.darkBlue)
                        .cornerRadius(10)
                }.sheet(isPresented: $showingRegister) {
                    RegisterView(isLoggedIn: $isLoggedIn)
                }
                
                Spacer()
                
                Text("Приложение для выбора дизайна ногтей")
                    .font(.caption)
                    .foregroundStyle(.lightPink)
            }
            .padding()
        }
    }
}

//#Preview {
//    LoginRegisterView()
//}
