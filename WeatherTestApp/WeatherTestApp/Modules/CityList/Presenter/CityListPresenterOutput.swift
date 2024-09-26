//
//  CityListPresenterOutput.swift
//  WeatherTestApp
//
//  Created by Maksim Sannikov on 26.09.2024.
//

import Foundation

/// Протокол, определяющий методы для обновления представления списка городов.
protocol CityListPresenterOutput: AnyObject {
    
    /// Отображает список городов с данными о погоде.
    /// - Parameter cities: Массив данных о погоде для городов.
    func showCities(_ cities: [WeatherResponse])
    
    /// Отображает сообщение об ошибке.
    /// - Parameter message: Текст сообщения об ошибке.
    func showError(_ message: String)
}
