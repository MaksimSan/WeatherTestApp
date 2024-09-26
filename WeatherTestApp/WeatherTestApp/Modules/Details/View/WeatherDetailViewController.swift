//
// WeatherDetailViewController.swift
// WeatherTestApp
//
//  Created by Maksim Sannikov on 26.09.2024.
//

import UIKit

final class WeatherDetailViewController: UIViewController {
    
    // MARK: - Private properties
    private let cityNameLabel = UILabel()
    private let currentDateLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let weatherDescriptionLabel = UILabel()
    private let weatherIconImageView = UIImageView()
    private let forecastSegmentedControl = UISegmentedControl(
        items: [Constants.forecastSegment3Days, Constants.forecastSegment7Days]
    )
    private let forecastTableView = UITableView()
    private var presenter: WeatherDetailPresenter?
    private var forecastData: [WeatherViewModel.Forecast] = []

    private enum Constants {
        static let cityNameFontSize: CGFloat = 24
        static let currentDateFontSize: CGFloat = 16
        static let temperatureFontSize: CGFloat = 20
        static let descriptionFontSize: CGFloat = 16
        static let weatherIconSize: CGFloat = 50
        static let tableRowHeight: CGFloat = 100
        static let padding: CGFloat = 20
        static let smallPadding: CGFloat = 10

        static let forecastSegment3Days = "3 Days"
        static let forecastSegment7Days = "7 Days"
        static let todayText = "Today"
        static let errorTitle = "Error"
        static let okActionTitle = "OK"
        static let forecastCellIdentifier = "ForecastCell"
        static let dateFormat = "E, d MMM"
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupLayoutConstraints()
        presenter?.viewDidLoad()
        forecastSegmentedControl.addTarget(self, action: #selector(forecastPeriodChanged(_:)), for: .valueChanged)
        forecastSegmentedControl.selectedSegmentIndex = 0
    }
    
    // MARK: - Configuration
    func configure(presenter: WeatherDetailPresenter) {
        self.presenter = presenter
    }

    // MARK: - Private Methods
    private func setupViews() {
        setupLabel(cityNameLabel, fontSize: Constants.cityNameFontSize, isBold: true)
        setupLabel(currentDateLabel, fontSize: Constants.currentDateFontSize, textColor: .gray)
        setupLabel(temperatureLabel, fontSize: Constants.temperatureFontSize)
        setupLabel(weatherDescriptionLabel, fontSize: Constants.descriptionFontSize)
        setupWeatherIconImageView()
        setupForecastSegmentedControl()
        setupForecastTableView()
    }

    private func setupLabel(_ label: UILabel, fontSize: CGFloat, textColor: UIColor = .black, isBold: Bool = false) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = isBold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
        label.textColor = textColor
        view.addSubview(label)
    }

    private func setupWeatherIconImageView() {
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        weatherIconImageView.contentMode = .scaleAspectFit
        view.addSubview(weatherIconImageView)
    }

    private func setupForecastSegmentedControl() {
        forecastSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(forecastSegmentedControl)
    }

    private func setupForecastTableView() {
        forecastTableView.translatesAutoresizingMaskIntoConstraints = false
        forecastTableView.dataSource = self
        forecastTableView.delegate = self
        forecastTableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: Constants.forecastCellIdentifier)
        view.addSubview(forecastTableView)
    }

    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            cityNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.padding),
            cityNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            currentDateLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: Constants.smallPadding),
            currentDateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            weatherIconImageView.topAnchor.constraint(equalTo: currentDateLabel.bottomAnchor, constant: Constants.smallPadding),
            weatherIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherIconImageView.widthAnchor.constraint(equalToConstant: Constants.weatherIconSize),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: Constants.weatherIconSize),

            temperatureLabel.topAnchor.constraint(equalTo: weatherIconImageView.bottomAnchor, constant: Constants.smallPadding),
            temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            weatherDescriptionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: Constants.smallPadding),
            weatherDescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            forecastSegmentedControl.topAnchor.constraint(equalTo: weatherDescriptionLabel.bottomAnchor, constant: Constants.padding),
            forecastSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            forecastTableView.topAnchor.constraint(equalTo: forecastSegmentedControl.bottomAnchor, constant: Constants.padding),
            forecastTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            forecastTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            forecastTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Actions
    @objc private func forecastPeriodChanged(_ sender: UISegmentedControl) {
        let days = sender.selectedSegmentIndex == 0 ? 3 : 7
        presenter?.didChangeForecastPeriod(to: days)
    }
}

// MARK: - WeatherDetailPresenterOutput
extension WeatherDetailViewController: WeatherDetailPresenterOutput {
    func showWeatherDetails(_ weatherDetails: WeatherViewModel) {
        cityNameLabel.text = weatherDetails.city
        currentDateLabel.text = Constants.todayText
        temperatureLabel.text = weatherDetails.temperature
        weatherDescriptionLabel.text = weatherDetails.description
        presenter?.loadImage(for: weatherDetails.iconName) { [weak self] image in
            self?.weatherIconImageView.image = image
        }
    }

    func showForecast(_ forecast: [WeatherViewModel.Forecast]) {
        self.forecastData = forecast
        forecastTableView.reloadData()
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: Constants.errorTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.okActionTitle, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension WeatherDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.forecastCellIdentifier, for: indexPath) as? ForecastTableViewCell else {
            return UITableViewCell()
        }
        let forecast = forecastData[indexPath.row]

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormat
        let dateString = dateFormatter.string(from: forecast.date)

        presenter?.loadImage(for: forecast.iconName) { image in
            cell.configure(date: dateString, temperature: forecast.temperature, description: forecast.description, icon: image)
        }

        return cell
    }
}

// MARK: - UITableViewDelegate
extension WeatherDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.tableRowHeight
    }
}
