//
//  StringExtension.swift
//  designUp
//
//  Created by София Кармаева on 4/4/2025.
//

import UIKit

extension String {
    func imageFromBase64String() -> UIImage? {
        // Удаляем возможные пробелы и символы новой строки
        let trimmedString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Преобразуем строку Base64 в данные
        if let imageData = Data(base64Encoded: trimmedString, options: .ignoreUnknownCharacters) {
            // Создаем изображение из данных
            return UIImage(data: imageData)
        }
        
        return nil // Возвращаем nil, если преобразование не удалось
    }
}

