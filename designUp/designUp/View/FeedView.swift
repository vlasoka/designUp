//
//  FeedView.swift
//  designUp
//
//  Created by София Кармаева on 27/3/2025.
//

import SwiftUI

struct FeedView: View {
    @ObservedObject var networkManager = NetworkManager()
    @State private var showingFoundPosts = false
    @State private var tag: String = ""
    @State private var tags: [String] = []
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        ZStack {
            Color.lightPink.ignoresSafeArea()
            
            VStack {
                HStack {
                    TextField("Тег для поиска", text: $tag)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundStyle(.darkBlue)
                    Button(action: {
                        if tag.isEmpty {
                            showAlert.toggle()
                        } else {
                            tags.append(tag)
                            tag = ""
                        }
                    }) {
                        Text("Добавить")
                            .padding()
                            .background(Color.lightPurple)
                            .foregroundColor(.darkBlue)
                            .cornerRadius(8)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Ошибка"), message: Text("Введите тег"), dismissButton: .default(Text("ОК")))
                    } 
                }
                .padding(.horizontal)
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .foregroundStyle(.darkBlue)
                }
                
                HStack {
                    Spacer()
                    Button(action: {
                        tag = ""
                        tags = []
                    }) {
                        Text("Очистить")
                            .padding()
                            .background(Color.lightPurple)
                            .foregroundColor(.darkBlue)
                            .cornerRadius(8)
                    }
                    Spacer()
                    Button(action: {
                        findPosts()
                    }) {
                        Text("Найти")
                            .padding()
                            .background(Color.lightPurple)
                            .foregroundColor(.darkBlue)
                            .cornerRadius(8)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Ошибка"), message: Text(alertMessage), dismissButton: .default(Text("ОК")))
                    }
                    .sheet(isPresented: $showingFoundPosts) {
                        SearchResultsView(tags: tags)
                    }
                    Spacer()
                }
                
                List {
                    ForEach(networkManager.posts) { post in
                        PostsView(post: post, backColor: .lightPink)
                    }
                }
                .background(Color.lightPink)
                .scrollContentBackground(.hidden)
                .onAppear() {
                    networkManager.getAllPosts()
                }
            }
        }
    }
    
    func findPosts() {
        if tags.isEmpty {
            alertMessage = "Для поиска постов нужно написать теги."
            showAlert = true
        } else {
            showingFoundPosts.toggle()
        }
    }
}

#Preview {
    FeedView()
}
