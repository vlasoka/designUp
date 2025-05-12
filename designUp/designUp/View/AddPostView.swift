//
//  AddPostView.swift
//  designUp
//
//  Created by София Кармаева on 4/4/2025.
//

import SwiftUI

struct AddPostView: View {
    @ObservedObject var networkManager = NetworkManager()
    @State private var userLogin: String = UserDefaults.standard.string(forKey: K.userLogin) ?? ""
    @State private var image: UIImage?
    @State private var showImagePicker: Bool = false
    @State private var tag: String = ""
    @State private var tags: [String] = []
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.lightPurple.ignoresSafeArea()
            
            VStack {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                
                Button(action: {
                    showImagePicker.toggle()
                }) {
                    Text("Выбрать фото")
                        .padding()
                        .background(Color.lightPink)
                        .foregroundColor(.darkBlue)
                        .cornerRadius(8)
                }
                HStack {
                    TextField("Тег", text: $tag)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundStyle(.darkBlue)
                        .padding()
                    Button(action: {
                        addTag()
                    }) {
                        Text("Добавить")
                            .padding()
                            .background(Color.lightPink)
                            .foregroundColor(.darkBlue)
                            .cornerRadius(8)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Ошибка"), message: Text("Введите тег"), dismissButton: .default(Text("ОК")))
                    }
                }
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .foregroundStyle(.darkBlue)
                }
                HStack {
                    Button(action: {
                        if !tags.isEmpty {
                            tags.removeLast()
                        }
                    }) {
                        Text("Удалить последний")
                            .padding()
                            .background(Color.lightPink)
                            .foregroundColor(.darkBlue)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        tags = []
                    }) {
                        Text("Очистить")
                            .padding()
                            .background(Color.lightPink)
                            .foregroundColor(.darkBlue)
                            .cornerRadius(8)
                    }
                }
                Button(action: {
                    addPost()
                }) {
                    Text("Опубликовать")
                        .padding()
                        .background(Color.lightPink)
                        .foregroundColor(.darkBlue)
                        .cornerRadius(8)
                }
                .padding()
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Ошибка"), message: Text(alertMessage), dismissButton: .default(Text("ОК")))
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $image)
            }
        }
    }
    
    func addTag() {
        if tag.isEmpty {
            alertMessage = "Введите тег."
            showAlert = true
        } else {
            tags.append(tag)
            tag = ""
        }
    }
    
    func addPost() {
        if image == nil || tags.isEmpty {
            alertMessage = "Для публикации поста нужно выбрать фото и подписать теги."
            showAlert = true
        } else {
            networkManager.addPost(login: userLogin, photo: image, tags: tags)
            presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    AddPostView()
}
