//
//  PostsView.swift
//  designUp
//
//  Created by София Кармаева on 3/4/2025.
//

import SwiftUI

struct PostsView: View {
    var post: Post
    @State var backColor: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            let imageString = post.photo
            if let image = imageString.imageFromBase64String() {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            LazyVStack() {
                ForEach(post.tags, id: \.self) { tag in
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(backColor)
                        Text(tag)
                            .font(.title3)
                            .foregroundColor(.darkBlue)
                    }
                }
            }
        }
        .padding()
    }
}

//#Preview {
//    PostsView()
//}
