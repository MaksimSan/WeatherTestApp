//
//  WeatherDetailInteractorProtocol.swift
//  WeatherTestApp
//
//  Created by Maksim Sannikov on 26.09.2024.
//

import UIKit

/// Протокол для интерактора выходящих данных деталей погоды.
protocol WeatherDetailInteractorOutput: AnyObject {
    
    /// Обработка успешного получения данных о текущей погоде.
    /// - Parameter weatherData: Модель данных о погоде.
    func didFetchCurrentWeather(_ weatherData: WeatherResponse)
    
    /// Обработка успешного получения данных прогноза.
    /// - Parameter forecastData: Массив моделей данных прогноза.
    func didFetchForecast(_ forecastData: [WeatherViewModel.Forecast])
    
    /// Обработка ошибки при получении данных.
    /// - Parameter error: Ошибка.
    func didFailWithError(_ error: Error)
}
