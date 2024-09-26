//
//  SearchResultAssembly.swift
//  WeatherTestApp
//
//  Created by Maksim Sannikov on 26.09.2024.
//

import UIKit.UIViewController

final class SearchResultAssembly {
    
    func createSearchResultModule(delegate: SearchResultsControllerDelegate?) -> UIViewController {
        let networkManager = NetworkManagerImpl()
        let view = SearchResultViewController()
        let interactor = SearchResultInteractorImpl()
        let presenter = SearchResultPresenterImpl()
        let router = SearchResultRouterImpl()
        
        view.configure(presenter: presenter)
        presenter.configure(view: view, interactor: interactor, router: router, networkManager: networkManager)
        interactor.configure(presenter: presenter, networkManager: networkManager)
        router.viewController = view
        view.delegate = delegate
        let searchController = UISearchController(searchResultsController: view)
        searchController.searchResultsUpdater = view
        searchController.view.backgroundColor = .white
        searchController.obscuresBackgroundDuringPresentation = false
        
        return searchController
    }
}
