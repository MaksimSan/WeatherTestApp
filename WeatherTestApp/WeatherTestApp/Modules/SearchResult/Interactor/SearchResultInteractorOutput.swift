//
//  SearchResultInteractorOutput.swift
//  WeatherTestApp
//
//  Created by Maksim Sannikov on 26.09.2024.
//

import Foundation

/// Протокол, определяющий методы для получения данных от интерактора.
protocol SearchResultInteractorOutput: AnyObject {
    
    /// Вызывается при успешном получении списка городов.
    /// - Parameter cities: Массив городов.
    func didFetchCities(_ cities: [SearchResultResponse])
    
    /// Вызывается при возникновении ошибки.
    /// - Parameter error: Ошибка, возникшая при выполнении запроса.
    func didFailWithError(_ error: Error)
}
