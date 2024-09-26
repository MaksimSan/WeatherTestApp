//
// ForecastTableViewCell.swift
// WeatherTestApp
//
//  Created by Maksim Sannikov on 26.09.2024.
//

import UIKit

final class ForecastTableViewCell: UITableViewCell {
    
    // MARK: - Private properties
    private let dateLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let weatherIconImageView = UIImageView()
    
    private enum Constants {
        static let dateFontSize: CGFloat = 16
        static let temperatureFontSize: CGFloat = 18
        static let descriptionFontSize: CGFloat = 14
        static let cornerRadius: CGFloat = 8
        static let weatherIconSize: CGFloat = 40
        static let padding: CGFloat = 16
        static let interItemSpacing: CGFloat = 6
        static let backgroundColor: UIColor = UIColor(white: 0.9, alpha: 1)
    }
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = nil
        temperatureLabel.text = nil
        descriptionLabel.text = nil
        weatherIconImageView.image = nil
    }
    
    // MARK: - Public Methods
    func configure(date: String, temperature: String, description: String, icon: UIImage?) {
        dateLabel.text = date
        temperatureLabel.text = temperature
        descriptionLabel.text = description.capitalized
        weatherIconImageView.image = icon
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        setupWeatherIconImageView()
        setupDateLabel()
        setupTemperatureLabel()
        setupDescriptionLabel()
        setupContentView()
    }
    
    private func setupDateLabel() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.systemFont(ofSize: Constants.dateFontSize)
        dateLabel.textColor = .darkGray
        contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: weatherIconImageView.trailingAnchor, constant: Constants.padding),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding)
        ])
    }
    
    private func setupTemperatureLabel() {
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.font = UIFont.boldSystemFont(ofSize: Constants.temperatureFontSize)
        temperatureLabel.textColor = .black
        contentView.addSubview(temperatureLabel)
        NSLayoutConstraint.activate([
            temperatureLabel.leadingAnchor.constraint(equalTo: weatherIconImageView.trailingAnchor, constant: Constants.padding),
            temperatureLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Constants.interItemSpacing)
        ])
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: Constants.descriptionFontSize)
        descriptionLabel.textColor = .gray
        descriptionLabel.numberOfLines = 0
        contentView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: Constants.interItemSpacing),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.padding)
        ])
    }
    
    private func setupWeatherIconImageView() {
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        weatherIconImageView.contentMode = .scaleAspectFit
        contentView.addSubview(weatherIconImageView)
        NSLayoutConstraint.activate([
            weatherIconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            weatherIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weatherIconImageView.widthAnchor.constraint(equalToConstant: Constants.weatherIconSize),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: Constants.weatherIconSize)
        ])
    }
    
    private func setupContentView() {
        contentView.backgroundColor = Constants.backgroundColor
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.layer.masksToBounds = true
    }
}
