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
        VStack {
            let imageString = post.photo
            if let image = imageString.imageFromBase64String() {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            FlowLayout(items: post.tags) { tag in
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(backColor)
                    Text(tag)
                        .foregroundColor(.darkBlue)
                        .padding(8)
                }
            }
            .padding()
        }
        .padding()
    }
}

//#Preview {
//    PostsView()
//}

struct FlowLayout<Content: View>: View {
    var items: [String]
    var content: (String) -> Content
    
    var body: some View {
        var rows: [[String]] = []
        var currentRow: [String] = []
        var currentWidth: CGFloat = 0
        
        let screenWidth = UIScreen.main.bounds.width // Определяем ширину экрана
        
        // Проходим по всем элементам и группируем их в строки
        for item in items {
            let itemWidth = item.size(withAttributes: [.font: UIFont.systemFont(ofSize: 20)]).width + 16 // 16 - padding
            
            if currentWidth + itemWidth > screenWidth {
                // Если текущая ширина превышает ширину экрана, сохраняем текущую строку и начинаем новую
                rows.append(currentRow)
                currentRow = [item]
                currentWidth = itemWidth
            } else {
                currentRow.append(item)
                currentWidth += itemWidth
            }
        }
        
        // Добавляем последнюю строку, если она не пустая
        if !currentRow.isEmpty {
            rows.append(currentRow)
        }
        
        return VStack(alignment: .center) {
            ForEach(rows, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { item in
                        content(item)
                            .fixedSize(horizontal: true, vertical: true)
                    }
                }
                .padding(.bottom, 4) // Отступ между строками
            }
        }
    }
}


