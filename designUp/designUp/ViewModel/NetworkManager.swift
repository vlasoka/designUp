//
//  NetworkManager.swift
//  designUp
//
//  Created by София Кармаева on 2/4/2025.
//

import Foundation
import UIKit
import SwiftUICore

class NetworkManager: ObservableObject {
    @Published var posts = [Post]()
    @Published var postsByMaster = [Post]()
    @Published var postsByTags = [Post]()
    @Published var master: Master?
    @Published var isLoading = true
    
    let baseURLString = "http://127.0.0.1:5000"
    
    func addMaster(master: Master) {
        guard let url = URL(string: "\(baseURLString)/addMaster") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(master)
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    print("Error adding master: \(error)")
                } else {
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    UserDefaults.standard.set(master.login, forKey: K.userLogin)
                    self.isLoading = false
                }
            }
            task.resume()
        } catch {
            print("Error encoding master: \(error)")
        }
    }
    
    func loginMaster(login: String, password: String) {
        guard let url = URL(string: "\(baseURLString)/login") else { return }
        
        let parameters = ["login": login, "password": password]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Установка тела запроса
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Error serializing JSON: \(error)")
        }
        
        // Создание и запуск задачи
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
            }
            
            guard let data = data else { return }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let message = jsonResponse["message"] as? String {
                    if message == "Login successful" {
                        UserDefaults.standard.set(true, forKey: K.isLoggedInInfoKey)
                        UserDefaults.standard.set(login, forKey: K.userLogin)
                        // Здесь нужно убедиться, что вы правильно присваиваете master
                        if let masterAvatar = jsonResponse["avatar"] as? String {
                            let masterCity = jsonResponse["city"] as? String
                            let masterPhone = jsonResponse["phone"] as? String
                            DispatchQueue.main.async {
                                self.master = Master(login: login, password: password, avatar: masterAvatar, city: masterCity, phone: masterPhone)
                                self.isLoading = false
                            }
                        }
                    } else {
                        print(message)
                    }
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        task.resume()
    }
    
    func getMaster(login: String) {
        guard let url = URL(string: "\(baseURLString)/master/\(login)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
            }
            if let data = data {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let password = jsonResponse["password"] as? String, let masterAvatar = jsonResponse["avatar"] as? String {
                        DispatchQueue.main.async {
                            self.master = Master(login: login, password: password, avatar: masterAvatar)
                            self.isLoading = false
                        }
                    }
                } catch {
                    print("Error: \(error)")
                }
            }
        }
        task.resume()
    }
    
    func addPost(login: String, photo: UIImage?, tags: [String], likes: Int = 0) {
        guard let url = URL(string: "\(baseURLString)/addPost") else { return }
        
        guard let photo = photo, let imageData = photo.jpegData(compressionQuality: 1.0) else { return }
        let base64Photo = imageData.base64EncodedString()
        
        let parameters: [String: Any] = [
            "author_login": login,
            "photo": base64Photo,
            "tags": tags,
            "likes": likes
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Error in JSON serialization")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
            }
            
            guard let data = data else { return }
            
            if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],let message = jsonResponse["message"] as? String {
                print(message)
                self.getPostsByMaster(masterLogin: login)
            }
        }.resume()
    }
    
    func getAllPosts() {
        guard let url = URL(string: "\(baseURLString)/getAllPosts") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching posts: \(error)")
            }
            if let data = data {
                do {
                    let newPosts = try JSONDecoder().decode([Post].self, from: data)
                    DispatchQueue.main.async {
                        self.posts = newPosts
                    }
                } catch {
                    print("Error decoding posts: \(error)")
                }
            }
        }
        task.resume()
    }

    func getPostsByMaster(masterLogin: String) {
        guard let url = URL(string: "\(baseURLString)/posts/\(masterLogin)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching posts by master: \(error)")
                return
            }
            if let data = data  {
                do {
                    let newPosts = try JSONDecoder().decode([Post].self, from: data)
                    DispatchQueue.main.async {
                        self.postsByMaster = newPosts
                    }
                } catch {
                    print("Error decoding posts by master: \(error)")
                }
            }
        }
        task.resume()
    }
    
    func getPostsByTags(tags: [String]) {
        guard let url = URL(string: "\(baseURLString)/postsByTags") else { return }
        let parameters = ["tags": tags]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Error in JSON serialization")
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
            }
            guard let data = data else { return }
            if let postsResponse = try? JSONDecoder().decode([Post].self, from: data) {
                print("Successfully got posts by tags")
                DispatchQueue.main.async {
                    self.postsByTags = postsResponse
                }
            }
        }.resume()
    }
    
    func addToFavourites(owner_login: String, post_id: String) {
        let url = URL(string: "\(baseURLString)/addToFavourites")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body: [String: Any] = ["owner_login": owner_login, "post_id": post_id]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Error adding post to favourite: \(error)")
            }
        }
        task.resume()
    }
    
    func getFavourites(login: String) {
        guard let url = URL(string: "\(baseURLString)/favourites/\(login)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
            }
            
            guard let data = data else { return }
            
            if let postsResponse = try? JSONDecoder().decode([Post].self, from: data) {
                DispatchQueue.main.async {
                    self.posts = postsResponse
                }
            }
        }.resume()
    }
    
    func removeFromFavourites(owner_login: String, post_id: Int) {
        guard let url = URL(string: "\(baseURLString)/favourites/\(owner_login)/\(post_id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        let body: [String: Any] = ["owner_login": owner_login, "post_id": post_id]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error removing from favourites: \(error)")
                }
            }.resume()
        } catch {
            print("Error removing from favourite: \(error)")
        }
    }
    
    func deletePost(post_id: Int) {
        guard let url = URL(string: "\(baseURLString)/deletePost/\(post_id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error deleting post: \(error)")
                return
            }
        }.resume()
    }
}
