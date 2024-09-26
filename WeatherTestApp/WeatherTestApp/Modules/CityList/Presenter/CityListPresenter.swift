//
//  CityListPresenter.swift
//  WeatherTestApp
//
//  Created by Maksim Sannikov on 26.09.2024.
//

import Foundation

/// Протокол, определяющий методы для управления представлением списка городов.
protocol CityListPresenter: AnyObject {
    
    /// Вызывается при загрузке представления.
    func viewDidLoad()
    
    /// Вызывается при выборе города.
    /// - Parameter city: Название выбранного города.
    func didSelectCity(_ city: String)
    
    /// Вызывается при добавлении нового города.
    /// - Parameters:
    ///   - city: Название добавляемого города.
    ///   - isInitialLoad: Флаг, указывающий на первоначальную загрузку.
    func addCity(_ city: String, isInitialLoad: Bool)
    
    /// Была нажата кнопка "Добавить город"
    func didTapAddCity()
    
    /// Вызывается при удалении города.
    /// - Parameter index: Индекс удаляемого города.
    func didDeleteCity(at index: Int)
}

final class CityListPresenterImpl {
    
    // MARK: - Public properties
    weak var view: CityListPresenterOutput?
    var interactor: CityListInteractorInput?
    var router: CityListRouter?
    var networkManager: NetworkManager?
    
    // MARK: - Private properties
    private var cities: [String] = []
    private var weatherData: [String: WeatherResponse] = [:]
    private var loadingCities: Set<String> = []
    
    // MARK: - Configuration
    func configure(
        view: CityListPresenterOutput,
        interactor: CityListInteractorInput,
        router: CityListRouter,
        networkManager: NetworkManager
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.networkManager = networkManager
    }
}

// MARK: - CityListPresenterImpl + Private
private extension CityListPresenterImpl {
    
    func updateView() {
        let cityWeatherModels = cities.compactMap { weatherData[$0] }
        view?.showCities(cityWeatherModels)
    }
    
    func cleanCityName(_ city: String) -> String {
        return city.components(separatedBy: ",").first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? city
    }
}

// MARK: - CityListPresenterImpl + CityListPresenter
extension CityListPresenterImpl: CityListPresenter {
    
    func viewDidLoad() {
        interactor?.fetchCities()
    }
    
    func didSelectCity(_ city: String) {
        guard let weather = weatherData[city] else { return }
        router?.showWeatherDetail(for: city, with: weather)
    }
    
    func didTapAddCity() {
        router?.showSearchResult()
    }
    
    func addCity(_ city: String, isInitialLoad: Bool = false) {
        let cleanedCity = cleanCityName(city)
        guard 
            !cities.contains(cleanedCity),
            !loadingCities.contains(cleanedCity)
        else { return }
        loadingCities.insert(cleanedCity)
        
        if isInitialLoad {
            cities.append(cleanedCity)
        }
        
        interactor?.fetchWeather(for: cleanedCity)
    }
    
    func didDeleteCity(at index: Int) {
        let city = cities.remove(at: index)
        weatherData.removeValue(forKey: city)
        updateView()
    }
}


// MARK: - CityListPresenterImpl + CityListInteractorOutput
extension CityListPresenterImpl: CityListInteractorOutput {
    
    func didFetchCities(_ cities: [String]) {
        let cleanedCities = cities.map { cleanCityName($0) }
        for city in cleanedCities {
            addCity(city, isInitialLoad: true)
        }
    }
    
    func didFetchWeather(for city: String, weather: WeatherResponse) {
        let cleanedCity = cleanCityName(city)
        weatherData[cleanedCity] = weather
        loadingCities.remove(cleanedCity)
        if !cities.contains(cleanedCity) {
            cities.append(cleanedCity)
        }
        updateView()
    }
    
    func didFailWithError(_ error: Error) {
        view?.showError(error.localizedDescription)
    }
}
