//
//  WeatherViewModel.swift
//  WeatherTestApp
//
//  Created by Maksim Sannikov on 26.09.2024.
//

import Foundation

/// Модель погоды для отображение на UI
struct WeatherViewModel {
    
    /// Наименование города
    let city: String
    /// Температура
    let temperature: String
    /// Описание погоды
    let description: String
    /// Наименование иконки погодных условий
    let iconName: String
    /// Список прогнозов погоды
    let forecasts: [Forecast]
    
    /// Прогноз погоды
    struct Forecast {
        
        /// Дата прогноза
        let date: Date
        /// Температура
        let temperature: String
        /// Описание погоды
        let description: String
        /// Наименование иконки погодных условий
        let iconName: String
    }
}

