//
// WeatherDetailInteractor.swift
// WeatherTestApp
//
//  Created by Maksim Sannikov on 26.09.2024.
//

import UIKit

/// Протокол для интерактора входящих данных деталей погоды.
protocol WeatherDetailInteractorInput: AnyObject {
    
    /// Получить подробную информацию о погоде.
    func fetchWeatherDetails()
    
    /// Получить прогноз погоды.
    /// - Parameter days: Количество дней прогноза.
    func fetchForecast(days: Int)
    
    /// Загрузить изображение для иконки погоды.
    /// - Parameter icon: Название иконки.
    /// - Parameter completion: Замыкание с результатом загрузки изображения.
    func loadImage(for icon: String, completion: @escaping (UIImage?) -> Void)
}

final class WeatherDetailInteractorImpl: WeatherDetailInteractorInput {
        
    // MARK: - Private properties
    private var networkManager: NetworkManager?
    private var city: String?
    private weak var presenter: WeatherDetailInteractorOutput?
    private var imageLoadingService: ImageLoadingService?

    private enum Constants {
        static let iconUrlPrefix = "https://openweathermap.org/img/wn/"
        static let iconUrlSuffix = "@2x.png"
    }
    
    // MARK: - Configuration
    func configure(city: String,
                   networkManager: NetworkManager,
                   presenter: WeatherDetailInteractorOutput,
                   imageLoadingService: ImageLoadingService) {
        self.city = city
        self.networkManager = networkManager
        self.presenter = presenter
        self.imageLoadingService = imageLoadingService
    }
    
    // MARK: - Public Methods
    func fetchWeatherDetails() {
        guard let city = city, let networkManager = networkManager else { return }
        networkManager.getWeather(for: city) { [weak self] response in
            DispatchQueue.main.async {
                switch response {
                case .success(let value):
                    self?.presenter?.didFetchCurrentWeather(value)
                case .failure(let error):
                    self?.presenter?.didFailWithError(error)
                }
            }
        }
    }
    
    func fetchForecast(days: Int) {
        guard let city = city, let networkManager = networkManager else { return }
        networkManager.getForecast(for: city, days: days) { [weak self] response in
            DispatchQueue.main.async {
                switch response {
                case .success(let value):
                    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!.startOfDay
                    let groupedForecasts = Dictionary(
                        grouping: value.forecasts, by: { Date(timeIntervalSince1970: $0.date).startOfDay }
                    )
                    let filteredForecasts = groupedForecasts.compactMap { (key, value) -> WeatherViewModel.Forecast? in
                        guard key >= tomorrow else { return nil }
                        guard let forecast = value.first(where: { Calendar.current.component(.hour, from: Date(timeIntervalSince1970: $0.date)) == 12 }) ?? value.max(by: { $0.mainInfo.temp < $1.mainInfo.temp }) else {
                            return nil
                        }
                        return WeatherViewModel.Forecast(
                            date: key,
                            temperature: "\(Int(forecast.mainInfo.temp.rounded()))°C",
                            description: forecast.weatherConditions.first?.description.capitalized ?? "",
                            iconName: forecast.weatherConditions.first?.icon ?? ""
                        )
                    }
                    self?.presenter?.didFetchForecast(filteredForecasts.sorted(by: { $0.date < $1.date }))
                case .failure(let error):
                    self?.presenter?.didFailWithError(error)
                }
            }
        }
    }
    
    func loadImage(for icon: String, completion: @escaping (UIImage?) -> Void) {
        guard let imageLoadingService, let iconUrl = URL(string: "\(Constants.iconUrlPrefix)\(icon)\(Constants.iconUrlSuffix)") else {
            completion(nil)
            return
        }
        imageLoadingService.loadImage(from: iconUrl, completion: completion)
    }
}
