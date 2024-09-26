//
//  SearchResultsController.swift
//  WeatherTestApp
//
//  Created by Maksim Sannikov on 26.09.2024.
//

import UIKit

/// Делегат для обработки выбора города из результатов поиска.
protocol SearchResultsControllerDelegate: AnyObject {
    
    /// Метод, вызываемый при выборе города.
    /// - Parameter city: Название выбранного города.
    func didSelectCity(_ city: String)
}

final class SearchResultViewController: UITableViewController {
    
    // MARK: - Public properties
    weak var delegate: SearchResultsControllerDelegate?
    
    // MARK: - Private properties
    private var suggestedCities: [String] = []
    private var presenter: SearchResultPresenter?
    
    private enum Constants {
        
        static let cellIdentifier = "SuggestionCell"
        static let errorTitle = "Error"
        static let okActionTitle = "OK"
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
    }
    
    // MARK: - Public Methods
    func configure(presenter: SearchResultPresenter) {
        self.presenter = presenter
    }
}

// MARK: - UITableViewDataSource
extension SearchResultViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestedCities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        cell.textLabel?.text = suggestedCities[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchResultViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = suggestedCities[indexPath.row]
        delegate?.didSelectCity(city)
        presenter?.didSelectCity()
    }
}

// MARK: - UISearchResultsUpdating
extension SearchResultViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, searchText.count > 2 else {
            suggestedCities = []
            tableView.reloadData()
            return
        }
        
        presenter?.didSearchCity(searchText)
    }
}

// MARK: - SearchResultPresenterOutput
extension SearchResultViewController: SearchResultPresenterOutput {
    
    func showCities(_ cities: [String]) {
        suggestedCities = cities
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: Constants.errorTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.okActionTitle, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
