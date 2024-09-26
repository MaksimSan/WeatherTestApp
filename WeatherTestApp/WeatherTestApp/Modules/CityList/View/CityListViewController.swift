//
//  CityListViewController.swift
//  WeatherTestApp
//
//  Created by Maksim Sannikov on 26.09.2024.
//

import UIKit

final class CityListViewController: UIViewController {
    
    // MARK: - Private properties
    private var cities: [WeatherResponse] = []
    private let tableView = UITableView()
    
    private enum Constants {
        
        static let title = "Weather"
        static let cellIdentifier = "CityCell"
        static let errorTitle = "Error"
        static let okActionTitle = "OK"
    }
    private var presenter: CityListPresenter?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        presenter?.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        deselectAllRows()
    }
    
    // MARK: - Configuration
    func configure(presenter: CityListPresenter) {
        self.presenter = presenter
    }
    
    // MARK: - Private Methods
    private func setupNavigationBar() {
        title = Constants.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(didTapAddCity))
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func deselectAllRows() {
        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else { return }
        for indexPath in selectedIndexPaths {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    // MARK: - Actions
    @objc private func didTapAddCity() {
        presenter?.didTapAddCity()
    }
}

// MARK: - CityListPresenterOutput
extension CityListViewController: CityListPresenterOutput {
    
    func showCities(_ cities: [WeatherResponse]) {
        self.cities = cities
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: Constants.errorTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.okActionTitle, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension CityListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.cellIdentifier,
            for: indexPath
        ) as? CityTableViewCell else {
            return UITableViewCell()
        }
        
        let cityWeather = cities[indexPath.row]
        let temperature = "\(Int(cityWeather.mainInfo.temp.rounded()))°C"
        cell.configure(city: cityWeather.name, temperature: temperature)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CityListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityWeather = cities[indexPath.row]
        presenter?.didSelectCity(cityWeather.name)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        presenter?.didDeleteCity(at: indexPath.row)
    }
}

// MARK: - SearchResultsControllerDelegate
extension CityListViewController: SearchResultsControllerDelegate {
    
    func didSelectCity(_ city: String) {
        presenter?.addCity(city, isInitialLoad: false)
    }
}
