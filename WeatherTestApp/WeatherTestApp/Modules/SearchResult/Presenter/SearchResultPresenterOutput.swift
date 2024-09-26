//
//  SearchResultPresenterOutput.swift
//  WeatherTestApp
//
//  Created by Maksim Sannikov on 26.09.2024.
//

/// Протокол, определяющий методы для обновления представления списка городов.
protocol SearchResultPresenterOutput: AnyObject {
    
    /// Показать список городов
    /// - Parameter cities: Список городов
    func showCities(_ cities: [String])
    
    /// Отображает сообщение об ошибке.
    /// - Parameter message: Текст сообщения об ошибке.
    func showError(_ message: String)
}
