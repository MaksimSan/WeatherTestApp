//
//  CityListInteractor.swift
//  WeatherTestApp
//
//  Created by Maksim Sannikov on 26.09.2024.
//

import Foundation

/// Протокол, определяющий методы для взаимодействия с сетевыми запросами.
protocol CityListInteractorInput: AnyObject {
    
    /// Извлекает список городов.
    func fetchCities()
    
    /// Извлекает данные о погоде для указанного города.
    /// - Parameter city: Название города.
    func fetchWeather(for city: String)
}

final class CityListInteractorImpl: CityListInteractorInput {
    
    // MARK: - Public properties
    weak var presenter: CityListInteractorOutput?
    
    // MARK: - Private properties
    private var networkManager: NetworkManager?
    
    // MARK: - Configuration
    func configure(presenter: CityListInteractorOutput, networkManager: NetworkManager) {
        self.presenter = presenter
        self.networkManager = networkManager
    }
    
    // MARK: - Public Methods
    func fetchCities() {
        let defaultCities = ["Moscow", "Perm"]
        presenter?.didFetchCities(defaultCities)
    }
    
    func fetchWeather(for city: String) {
        networkManager?.getWeather(for: city) { [weak self] response in
            DispatchQueue.main.async {
                switch response {
                case .success(let value):
                    self?.presenter?.didFetchWeather(for: city, weather: value)
                case .failure(let error):
                    self?.presenter?.didFailWithError(error)
                }
            }
        }
    }
}
