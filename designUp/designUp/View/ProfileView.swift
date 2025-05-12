//
//  ProfileView.swift
//  designUp
//
//  Created by София Кармаева on 27/3/2025.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var networkManager = NetworkManager()
    @State private var userLogin: String = UserDefaults.standard.string(forKey: K.userLogin) ?? ""
    @State private var image: UIImage? = nil
    @State private var isLoading = true
    @State private var showingAddPost = false
    
    var body: some View {
        ZStack {
            Color.lightPurple.ignoresSafeArea()
                        
            VStack {
                HStack {
                    if let imageString = networkManager.master?.avatar, let image = imageString.imageFromBase64String() {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 100)
                            .clipShape(Circle())
                    }

                    if let username = networkManager.master?.login {
                        Text(username)
                            .font(.title2)
                            .padding()
                    }
                }
                .padding()
                .onAppear() {
                    networkManager.getMaster(login: userLogin)
                }
                Divider().frame(height: 2).background(Color.darkBlue).padding(.horizontal)
                HStack {
                    Spacer()
                    Text("Посты")
                        .font(.title)
                        .foregroundStyle(.darkBlue)
                    Spacer()
                    Button(action: {
                        showingAddPost = true
                    }) {
                        Text(Image(systemName: "plus.app"))
                            .font(.largeTitle) // Изменение шрифта
                            .foregroundColor(Color.darkBlue) // Цвет текста
                    }
                    .padding(.horizontal)
                    .sheet(isPresented: $showingAddPost) {
                        AddPostView()
                    }
                }.padding(.maximum(2, 2))
                Divider().frame(height: 2).background(Color.darkBlue).padding(.horizontal)
                List {
                    ForEach(networkManager.postsByMaster) { post in
                        PostsView(post: post, backColor: .lightPurple)
                    }
                }
                .background(Color.lightPurple)
                .scrollContentBackground(.hidden)
                .onAppear() {
                    networkManager.getPostsByMaster(masterLogin: userLogin)
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
