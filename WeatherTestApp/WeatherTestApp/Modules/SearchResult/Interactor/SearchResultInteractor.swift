//
//  SearchResultInteractor.swift
//  WeatherTestApp
//
//  Created by Maksim Sannikov on 26.09.2024.
//

import Foundation

/// Протокол, определяющий методы для взаимодействия с сетевыми запросами.
protocol SearchResultInteractorInput: AnyObject {
    
    /// Выполняет поиск городов по запросу.
    /// - Parameter query: Поисковой запрос.
    func searchCities(with query: String)
}

final class SearchResultInteractorImpl: SearchResultInteractorInput {
    
    // MARK: - Public properties
    weak var presenter: SearchResultInteractorOutput?
    
    // MARK: - Private properties
    private var networkManager: NetworkManager?
    
    // MARK: - Configuration
    func configure(presenter: SearchResultInteractorOutput, networkManager: NetworkManager) {
        self.presenter = presenter
        self.networkManager = networkManager
    }
    
    // MARK: - Public Methods
    func searchCities(with query: String) {
        networkManager?.fetchSuggestedCities(for: query) { [weak self] response in
            DispatchQueue.main.async {
                switch response {
                case .success(let value):
                    self?.presenter?.didFetchCities(value)
                case .failure(let error):
                    self?.presenter?.didFailWithError(error)
                }
            }
        }
    }
}

