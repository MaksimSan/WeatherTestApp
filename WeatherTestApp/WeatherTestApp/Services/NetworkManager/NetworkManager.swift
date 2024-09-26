//
//  NetworkManaging.swift
//  WeatherTestApp
//
//  Created by Maksim Sannikov on 26.09.2024.
//

import Foundation

/// Протокол для управления сетевыми запросами.
protocol NetworkManager {
    
    /// Получает данные о погоде для указанного города.
    /// - Parameters:
    ///   - city: Название города.
    ///   - completion: Замыкание, вызываемое при завершении запроса. Возвращает объект `CityWeather` или nil в случае ошибки.
    func getWeather(for city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void)
    
    /// Получает список предложенных городов для указанного запроса.
    /// - Parameters:
    ///   - query: Поисковой запрос.
    ///   - completion: Замыкание, вызываемое при завершении запроса. Возвращает массив строк с предложенными городами.
    func fetchSuggestedCities(for query: String, completion: @escaping (Result<[SearchResultResponse], Error>) -> Void)
    
    /// Получает прогноз погоды для указанного города на заданное количество дней.
    /// - Parameters:
    ///   - city: Название города.
    ///   - days: Количество дней для прогноза.
    ///   - completion: Замыкание, вызываемое при завершении запроса. Возвращает объект `ForecastData` или nil в случае ошибки.
    func getForecast(for city: String, days: Int, completion: @escaping (Result<ForecastResponse, Error>) -> Void)
}


final class NetworkManagerImpl: NetworkManager {
    // MARK: - Constants
    private enum Constants {
        
        static let apiKey = "43887baaec0022d4b7744d2498f8907c"
        static let weatherBaseUrl = "https://api.openweathermap.org/data/2.5/weather"
        static let forecastBaseUrl = "https://api.openweathermap.org/data/2.5/forecast"
        static let geocodingBaseUrl = "https://api.openweathermap.org/geo/1.0/direct"
        static let metricUnits = "metric"
        static let geocodingLimit = "5"
        static let errorCode = 204
        static let errorDomain = "No data"
    }
    
    // MARK: - Public Methods
    func getWeather(for city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        let queryItems = [URLQueryItem(name: "q", value: city),
                          URLQueryItem(name: "appid", value: Constants.apiKey),
                          URLQueryItem(name: "units", value: Constants.metricUnits)]
        var urlComps = URLComponents(string: Constants.weatherBaseUrl)
        urlComps?.queryItems = queryItems
        guard let url = urlComps?.url else { return }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }
            guard let data else {
                completion(.failure(NSError(domain: Constants.errorDomain, code: Constants.errorCode, userInfo: nil)))
                return
            }
            
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(.success(weatherResponse))
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }

    func getForecast(for city: String, days: Int, completion: @escaping (Result<ForecastResponse, Error>) -> Void) {
        let queryItems = [URLQueryItem(name: "q", value: city),
                          URLQueryItem(name: "cnt", value: String(days * 8)),
                          URLQueryItem(name: "appid", value: Constants.apiKey),
                          URLQueryItem(name: "units", value: Constants.metricUnits)]
        var urlComps = URLComponents(string: Constants.forecastBaseUrl)
        urlComps?.queryItems = queryItems
        guard let url = urlComps?.url else { return }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }
            guard let data else {
                completion(.failure(NSError(domain: Constants.errorDomain, code: Constants.errorCode, userInfo: nil)))
                return
            }
            
            do {
                let forecastResponse = try JSONDecoder().decode(ForecastResponse.self, from: data)
                completion(.success(forecastResponse))
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }

    func fetchSuggestedCities(for query: String, completion: @escaping (Result<[SearchResultResponse], Error>) -> Void) {
        let queryItems = [URLQueryItem(name: "q", value: query),
                          URLQueryItem(name: "limit", value: Constants.geocodingLimit),
                          URLQueryItem(name: "appid", value: Constants.apiKey)]
        var urlComps = URLComponents(string: Constants.geocodingBaseUrl)
        urlComps?.queryItems = queryItems
        guard let url = urlComps?.url else { return }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }
            guard let data else {
                completion(.failure(NSError(domain: Constants.errorDomain, code: Constants.errorCode, userInfo: nil)))
                return
            }
            
            do {
                let searchResultResponse = try JSONDecoder().decode([SearchResultResponse].self, from: data)
                completion(.success(searchResultResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
