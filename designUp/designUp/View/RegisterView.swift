//
//  RegisterView.swift
//  designUp
//
//  Created by София Кармаева on 26/3/2025.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var networkManager = NetworkManager()
    @Binding var isLoggedIn: Bool
    @State private var userLogin: String = ""
    @State private var image: UIImage?
    @State private var showImagePicker: Bool = false
    @State private var userPassword: String = ""
    @State private var userRepassword: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        ZStack {
            Color.darkBlue.ignoresSafeArea()
            
            VStack {
                Text("Регистрация")
                    .font(.largeTitle)
                    .foregroundStyle(.lightPurple)

                TextField("Логин", text: $userLogin)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundStyle(.darkBlue)
                    .padding()
                
                HStack {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 100)
                            .clipShape(Circle())
                    }
                    
                    Button(action: {
                        showImagePicker.toggle()
                    }) {
                        Text("Выбрать аватар")
                            .padding()
                            .background(Color.lightPurple)
                            .foregroundColor(.darkBlue)
                            .cornerRadius(8)
                    }
                }

                SecureField("Пароль", text: $userPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundStyle(.darkBlue)
                    .padding()
                
                SecureField("Подтвердите пароль", text: $userRepassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundStyle(.darkBlue)
                    .padding()
                
                Button(action: {
                    register()
                }) {
                    Text("Зарегистрироваться")
                        .font(.title2) // Изменение шрифта
                        .padding() // Отступы
                        .background(Color.lightPurple) // Цвет фона
                        .foregroundColor(Color.darkBlue) // Цвет текста
                        .cornerRadius(10) // Закругление углов
                }.padding()
                
                Text("*все поля обязательны для заполнения")
                    .font(.caption)
                    .foregroundStyle(.lightPurple)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Ошибка"), message: Text(alertMessage), dismissButton: .default(Text("ОК")))
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $image)
            }
            .padding()
        }
    }
    
    private func register() {
        if userLogin.isEmpty || userPassword.isEmpty || userRepassword.isEmpty || image == nil {
            alertMessage = "Заполните все поля."
            showAlert = true
        } else if userPassword != userRepassword {
            alertMessage = "Пароли не совпадают."
            showAlert = true
        } else {
            networkManager.addMaster(master: Master(login: userLogin, password: userPassword, avatar: (image?.toBase64())!))
        }
    }
}

//#Preview {
//    RegisterView()
//}
