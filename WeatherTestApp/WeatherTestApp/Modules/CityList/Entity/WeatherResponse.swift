//
//  WeatherResponse.swift
//  WeatherTestApp
//
//  Created by Maksim Sannikov on 26.09.2024.
//

import Foundation

/// Ответ от сервера с информацией о погоде
struct WeatherResponse: Decodable {
    
    /// Наименование города
    let name: String
    /// Основная информация о погоде
    let mainInfo: WeatherMainInfo
    /// Список погодных условий
    let weatherConditions: [WeatherCondition]
    
    enum CodingKeys: String, CodingKey {
        
        case name
        case mainInfo = "main"
        case weatherConditions = "weather"
    }
    
    /// Погодные условия
    struct WeatherCondition: Decodable {
        
        let description: String
        let icon: String
    }
    
    /// Основная информация о погоде
    struct WeatherMainInfo: Decodable {
        
        let temp: Double
    }
}
