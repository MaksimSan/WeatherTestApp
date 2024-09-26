//
//  CityListInteractorProtocol.swift
//  WeatherTestApp
//
//  Created by Maksim Sannikov on 26.09.2024.
//

import Foundation

/// Протокол, определяющий методы для получения данных от интерактора.
protocol CityListInteractorOutput: AnyObject {
    
    /// Вызывается при успешном получении списка городов.
    /// - Parameter cities: Массив названий городов.
    func didFetchCities(_ cities: [String])
    
    /// Вызывается при успешном получении данных о погоде для города.
    /// - Parameters:
    ///   - city: Название города.
    ///   - weather: Данные о погоде для города.
    func didFetchWeather(for city: String, weather: WeatherResponse)
    
    /// Вызывается при возникновении ошибки.
    /// - Parameter error: Ошибка, возникшая при выполнении запроса.
    func didFailWithError(_ error: Error)
}
