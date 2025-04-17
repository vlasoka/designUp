//
//  SearchResultsView.swift
//  designUp
//
//  Created by София Кармаева on 4/4/2025.
//

import SwiftUI

struct SearchResultsView: View {
    @ObservedObject var networkManager = NetworkManager()
    @State var tags: [String] 
    
    var body: some View {
        List {
            ForEach(networkManager.postsByTags) { post in
                PostsView(post: post, backColor: .lightPink)
            }
        }
        .background(Color.lightPink)
        .scrollContentBackground(.hidden)
        .onAppear() {
            networkManager.getPostsByTags(tags: tags)
        }
    }
}

//#Preview {
//    SearchResultsView()
//}
