//
//  WeatherDetailAssembly.swift
//  WeatherTestApp
//
//  Created by Maksim Sannikov on 26.09.2024.
//

import UIKit.UIViewController

final class WeatherDetailAssembly {
    
    func createWeatherDetailModule(city: String, networkManager: NetworkManager) -> UIViewController {
        let view = WeatherDetailViewController()
        let interactor = WeatherDetailInteractorImpl()
        let presenter = WeatherDetailPresenterImpl()
        let router = WeatherDetailRouterImpl()
        let imageLoadingService = ImageLoadingServiceImpl()
        
        view.configure(presenter: presenter)
        presenter.configure(view: view, interactor: interactor, router: router)
        interactor.configure(
            city: city,
            networkManager: networkManager,
            presenter: presenter,
            imageLoadingService: imageLoadingService
        )
        
        return view
    }
}
