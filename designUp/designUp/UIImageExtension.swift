//
//  UIImageExtension.swift
//  designUp
//
//  Created by София Кармаева on 4/4/2025.
//

import UIKit

extension UIImage {
    func toBase64() -> String? {
        // Преобразуем изображение в данные
        guard let imageData = self.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        
        // Кодируем данные в строку Base64
        let base64String = imageData.base64EncodedString()
        return base64String
    }
}

