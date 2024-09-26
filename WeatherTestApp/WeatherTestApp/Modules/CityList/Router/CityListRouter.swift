//
//  CityListRouter.swift
//  WeatherTestApp
//
//  Created by Maksim Sannikov on 26.09.2024.
//

import UIKit

/// Протокол, определяющий методы для навигации из списка городов.
protocol CityListRouter: AnyObject {
    
    /// Выполняет навигацию к экрану с деталями погоды для города.
    /// - Parameters:
    ///   - view: Представление, из которого выполняется навигация.
    ///   - city: Название города.
    ///   - weatherData: Данные о погоде для города.
    func showWeatherDetail(for city: String, with weatherData: WeatherResponse)
    
    func showSearchResult()
}

final class CityListRouterImpl: CityListRouter {
    
    // MARK: - Public properties
    weak var viewController: UIViewController?
    
    // MARK: - Public methods
    func showWeatherDetail(for city: String, with weatherData: WeatherResponse) {
        let weatherDetailViewController = WeatherDetailAssembly().createWeatherDetailModule(city: city, networkManager: NetworkManagerImpl())
        viewController?.navigationController?.pushViewController(weatherDetailViewController, animated: true)
    }
    
    func showSearchResult() {
        let searchController = SearchResultAssembly().createSearchResultModule(delegate: viewController as? CityListViewController)
        viewController?.present(searchController, animated: true, completion: nil)
    }
}
