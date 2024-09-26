//
//  WeatherDetailPresenterOutput.swift
//  WeatherTestApp
//
//  Created by Maksim Sannikov on 26.09.2024.
//

import Foundation

/// Протокол для представления деталей погоды.
protocol WeatherDetailPresenterOutput: AnyObject {
    
    /// Показать подробную информацию о погоде.
    /// - Parameter weatherDetails: Модель данных о погоде.
    func showWeatherDetails(_ weatherDetails: WeatherViewModel)
    
    /// Показать прогноз погоды.
    /// - Parameter forecast: Массив моделей данных прогноза.
    func showForecast(_ forecast: [WeatherViewModel.Forecast])
    
    /// Показать сообщение об ошибке.
    /// - Parameter message: Сообщение об ошибке.
    func showError(_ message: String)
}
