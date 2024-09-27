//
//  SearchResultPresenter.swift
//  WeatherTestApp
//
//  Created by Maksim Sannikov on 26.09.2024.
//

import Foundation

/// Протокол, определяющий методы для управления представлением списка городов.
protocol SearchResultPresenter: AnyObject {
    
    /// Вызывается при поиске города.
    /// - Parameter query: Поисковой запрос.
    func didSearchCity(_ query: String)
    
    /// Вызывается при выборе города
    func didSelectCity()
}

final class SearchResultPresenterImpl {
    
    // MARK: - Public properties
    weak var view: SearchResultPresenterOutput?
    var interactor: SearchResultInteractorInput?
    var router: SearchResultRouter?
    var networkManager: NetworkManager?
    
    // MARK: - Private properties
    private var cities: [String] = []
    private var weatherData: [String: WeatherResponse] = [:]
    private var loadingCities: Set<String> = []
    
    // MARK: - Configuration
    func configure(
        view: SearchResultPresenterOutput,
        interactor: SearchResultInteractorInput,
        router: SearchResultRouter,
        networkManager: NetworkManager
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.networkManager = networkManager
    }
}

// MARK: - SearchResultPresenterImpl + SearchResultPresenter
extension SearchResultPresenterImpl: SearchResultPresenter {
    
    func didSearchCity(_ query: String) {
        interactor?.searchCities(with: query)
    }
    
    func didSelectCity() {
        router?.closeModule()
    }
}


// MARK: - SearchResultPresenterImpl + SearchResultInteractorOutput
extension SearchResultPresenterImpl: SearchResultInteractorOutput {
    
    func didFetchCities(_ cities: [SearchResultResponse]) {
        let cities = cities.map { response in
            if let place = response.place {
                return "\(response.name), \(place)"
            } else {
                return response.name
            }
        }
        view?.showCities(cities)
    }
    
    func didFailWithError(_ error: Error) {
        view?.showError(error.localizedDescription)
    }
}
