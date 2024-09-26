//
//  ForecastResponse.swift
//  WeatherTestApp
//
//  Created by Maksim Sannikov on 26.09.2024.
//

import Foundation

struct ForecastResponse: Decodable {
    
    /// Список прогнозов
    let forecasts: [Forecast]
    
    enum CodingKeys: String, CodingKey {
        
        case forecasts = "list"
    }
    
    /// Прогноз погоды
    struct Forecast: Decodable {
        
        /// Время прогноза
        let date: TimeInterval
        /// Основная информация о погоде
        let mainInfo: WeatherResponse.WeatherMainInfo
        /// Список погодных условий
        let weatherConditions: [WeatherResponse.WeatherCondition]
        
        enum CodingKeys: String, CodingKey {
            
            case date = "dt"
            case mainInfo = "main"
            case weatherConditions = "weather"
        }
    }
}
