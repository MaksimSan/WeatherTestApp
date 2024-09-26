//
//  WeatherDetailPresenter.swift
//  WeatherTestApp
//
//  Created by Maksim Sannikov on 26.09.2024.
//

import UIKit

/// Протокол для презентера деталей погоды.
protocol WeatherDetailPresenter: AnyObject {
    
    /// Обработка события загрузки представления.
    func viewDidLoad()
    
    /// Обработка изменения периода прогноза.
    /// - Parameter days: Количество дней прогноза.
    func didChangeForecastPeriod(to days: Int)
    
    /// Загрузить изображение для иконки погоды.
    /// - Parameter icon: Название иконки.
    /// - Parameter completion: Замыкание с результатом загрузки изображения.
    func loadImage(for icon: String, completion: @escaping (UIImage?) -> Void)
}

final class WeatherDetailPresenterImpl {

    // MARK: - Private properties
    private enum Constants {
        
        static let defaultForecastDays = 3
    }
    private weak var view: WeatherDetailPresenterOutput?
    private var interactor: WeatherDetailInteractorInput?
    private var router: WeatherDetailRouter?
    
    // MARK: - Configuration
    func configure(
        view: WeatherDetailPresenterOutput,
        interactor: WeatherDetailInteractorInput,
        router: WeatherDetailRouter
    ) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }
}

// MARK: - WeatherDetailPresenterImpl + WeatherDetailPresenter
extension WeatherDetailPresenterImpl: WeatherDetailPresenter {
    
    func viewDidLoad() {
        interactor?.fetchWeatherDetails()
        interactor?.fetchForecast(days: Constants.defaultForecastDays)
    }

    func didChangeForecastPeriod(to days: Int) {
        interactor?.fetchForecast(days: days)
    }
    
    func loadImage(for icon: String, completion: @escaping (UIImage?) -> Void) {
        interactor?.loadImage(for: icon, completion: completion)
    }
}

// MARK: - WeatherDetailPresenterImpl + WeatherDetailInteractorOutput
extension WeatherDetailPresenterImpl: WeatherDetailInteractorOutput {
    
    func didFetchCurrentWeather(_ weatherData: WeatherResponse) {
        let weatherViewModel = WeatherViewModel(
            city: weatherData.name,
            temperature: "\(Int(weatherData.mainInfo.temp.rounded()))°C",
            description: weatherData.weatherConditions.first?.description.capitalized ?? "",
            iconName: weatherData.weatherConditions.first?.icon ?? "",
            forecasts: []
        )
        view?.showWeatherDetails(weatherViewModel)
    }

    func didFetchForecast(_ forecastData: [WeatherViewModel.Forecast]) {
        view?.showForecast(forecastData)
    }

    func didFailWithError(_ error: Error) {
        view?.showError(error.localizedDescription)
    }
}
