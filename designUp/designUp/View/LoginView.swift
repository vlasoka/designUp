//
//  LoginView.swift
//  designUp
//
//  Created by София Кармаева on 26/3/2025.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var networkManager = NetworkManager()
    @Binding var isLoggedIn: Bool
    @State private var userLogin: String = ""
    @State private var userPassword: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        ZStack {
            Color.darkBlue.ignoresSafeArea()
            
            VStack {
                Text("Вход")
                    .font(.largeTitle)
                    .foregroundStyle(.lightPurple)

                TextField("Логин", text: $userLogin)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundStyle(.darkBlue)
                    .padding()

                SecureField("Пароль", text: $userPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundStyle(.darkBlue)
                    .padding()
                
                Button(action: {
                    signIn()
                }) {
                    Text("Войти")
                        .font(.title2) // Изменение шрифта
                        .padding() // Отступы
                        .background(Color.lightPurple) // Цвет фона
                        .foregroundColor(Color.darkBlue) // Цвет текста
                        .cornerRadius(10) // Закругление углов
                }.padding()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Ошибка"), message: Text(alertMessage), dismissButton: .default(Text("ОК")))
            }
            .padding()
        }
    }
    
    private func signIn() {
        if userLogin.isEmpty || userPassword.isEmpty {
            alertMessage = "Заполните все поля."
            showAlert = true
        } else {
            networkManager.loginMaster(login: userLogin, password: userPassword)
        }
    }
}

//#Preview {
//    LoginView()
//}
