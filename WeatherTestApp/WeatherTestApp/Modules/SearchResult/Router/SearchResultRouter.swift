//
//  SearchResultRouter.swift
//  WeatherTestApp
//
//  Created by Maksim Sannikov on 26.09.2024.
//

import UIKit

/// Протокол для маршрутизатора деталей погоды.
protocol SearchResultRouter: AnyObject {
    
    /// Закрыть модуль
    func closeModule()
}

final class SearchResultRouterImpl: SearchResultRouter {
    
    // MARK: - Public properties
    weak var viewController: UIViewController?
    
    // MARK: - Public methods
    func closeModule() {
        viewController?.dismiss(animated: true)
    }
}
