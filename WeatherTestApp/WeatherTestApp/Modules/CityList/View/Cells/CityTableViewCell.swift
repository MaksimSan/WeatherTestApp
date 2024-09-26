//
//  CityTableViewCell.swift
//  WeatherTestApp
//
//  Created by Maksim Sannikov on 26.09.2024.
//

import UIKit

final class CityTableViewCell: UITableViewCell {
    
    // MARK: - Private properties
    private let cityLabel = UILabel()
    private let temperatureLabel = UILabel()
    
    private enum Constants {
        static let leadingPadding: CGFloat = 16
        static let trailingPadding: CGFloat = -16
    }
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCityLabel()
        setupTemperatureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(city: String, temperature: String?) {
        cityLabel.text = city
        temperatureLabel.text = temperature
    }
    
    // MARK: - Private Methods
    private func setupCityLabel() {
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cityLabel)
        NSLayoutConstraint.activate([
            cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingPadding),
            cityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func setupTemperatureLabel() {
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(temperatureLabel)
        NSLayoutConstraint.activate([
            temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingPadding),
            temperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
