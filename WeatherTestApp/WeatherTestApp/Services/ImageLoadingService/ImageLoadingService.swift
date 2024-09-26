//
// ImageLoadingService.swift
// WeatherTestApp
//
//  Created by Maksim Sannikov on 26.09.2024.
//

import UIKit

/// Протокол для сервиса загрузки изображений
protocol ImageLoadingService {
    
    /// Загрузка изображения по URL
    /// - Parameters:
    ///   - url: URL изображения
    ///   - completion: Замыкание с результатом загрузки изображения
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}

final class ImageLoadingServiceImpl: ImageLoadingService {
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}

