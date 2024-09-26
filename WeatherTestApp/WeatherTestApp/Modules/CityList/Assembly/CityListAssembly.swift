//
//  CityListAssembly.swift
//  WeatherTestApp
//
//  Created by Maksim Sannikov on 26.09.2024.
//

import UIKit.UIViewController

final class CityListAssembly {
    
    func createCityListModule() -> UIViewController {
        let networkManager = NetworkManagerImpl()
        let view = CityListViewController()
        let interactor = CityListInteractorImpl()
        let presenter = CityListPresenterImpl()
        let router = CityListRouterImpl()
        
        view.configure(presenter: presenter)
        presenter.configure(view: view, interactor: interactor, router: router, networkManager: networkManager)
        interactor.configure(presenter: presenter, networkManager: networkManager)
        router.viewController = view
        return view
    }
}
